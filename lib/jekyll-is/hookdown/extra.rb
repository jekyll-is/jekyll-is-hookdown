# frozen_string_literal: true

require 'kramdown'

require_relative 'jekyll_patch'

module JekyllIS::Hookdown

  class << self

    def register_element_hook owner, *elements, priority: Jekyll::Hooks::DEFAULT_PRIORITY, &block
      if enabled?
        priority = Jekyll::Hooks::priority_value(priority)
        setup_element_hooks
        obj = { priority: priority, block: block, owner: owner, elements: elements }
        idx = @hooks.find_index { priority <= it[:priority] }
        if idx
          @hooks.insert idx, obj
        else
          @hooks.push obj
        end
        block
      else
        false
      end
    end

    def unregister_element_hook block
      if @hooks
        @hooks.reject! { it[:block] == block }
      end
    end

    private

    def process_element page, element, parent: nil, index: nil
      @hooks.reverse_each do |obj|
        next unless obj[:elements].include?(element.type)
        block = obj[:block]
        result = block.call page, element
        case result
        when Kramdown::Element
          element = result
          parent.children[index] = element if parent && parent.children && index
        when nil
          # do nothing
        when :delete
          element = nil
          parent.children.delete_at index if parent && index
          break
        else
          Jekyll::logger.error JekyllIS::Hookdown::Info::NAME, "Invalid hook response: #{ result.inspect }"
        end
      end
      if element && element.children
        element.children.each_with_index do |child, idx|
          process_element page, child, parent: element, index: idx
        end
      end
      element
    end

    def setup_element_hooks owner
      unless @hooks
        @hooks = []
        Jekyll::Hooks.register owner, :post_parse do |page, document|
          process_element page, document.root
        end
      end
    end

  end

end
