# frozen_string_literal: true

require 'set'
require 'kramdown'

require_relative 'setup'

module JekyllIS::Hookdown

  class << self

    # @param [Symbol, Array<Symbol>] owner
    # @param [Array<Symbol>] elements
    # @param [Integer, Symbol] priority
    # @return [Proc, nil]
    # @yield Hook block
    # @yieldparam [Jekyll::Page, Jekyll::Document] page
    # @yieldparam [Kramdown::Element] element
    # @yieldreturn [nil, Kramdown::Element, :delete]
    def register_element_hook owner, *elements, priority: Jekyll::Hooks::DEFAULT_PRIORITY, &block
      if enabled?
        priority = Jekyll::Hooks::priority_value(priority)
        owners = owner.is_a?(Enumerable) ? owner.to_set : Set[ owner ]
        setup_element_hooks
        obj = { priority: priority, block: block, owners: owners, elements: elements.to_set }
        idx = @hooks.find_index { priority <= it[:priority] }
        if idx
          @hooks.insert idx, obj
        else
          @hooks.push obj
        end
        block
      else
        nil
      end
    end

    # @param [Proc] block
    # @return [void]
    def unregister_element_hook block
      if @hooks
        @hooks.reject! { it[:block] == block }
      end
      nil
    end

    private

    def process_element page, kind, collection, element, parent: nil, index: nil
      @hooks.reverse_each do |obj|
        next unless obj[:elements].include?(element.type)
        next unless obj[:owners].include?(kind) || obj[:owners].include?(collection)
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
          parent.children[index] = element if parent && parent.children && index
          break
        else
          Jekyll::logger.error JekyllIS::Hookdown::Info::NAME, "Invalid hook response: #{ result.inspect }"
        end
      end
      if element && element.children
        element.children.each_with_index do |child, idx|
          process_element page, kind, collection, child, parent: element, index: idx
        end
        element.children.compact!
      end
      element
    end

    def setup_element_hooks
      unless @hooks
        @hooks = []
        Jekyll::Hooks.register [ :pages, :documents ], :post_parse do |page, document|
          kind = case page
          when Jekyll::Page
            :pages
          when Jekyll::Document
            :documents
          else
            nil
          end
          collection = if page.respond_to?(:collection)
            page.collection&.label&.to_sym
          else
            nil
          end
          process_element page, kind, collection, document.root
        end
      end
    end

  end

end
