# frozen_string_literal: true

require 'jekyll'

require_relative 'info'

module JekyllIS::Hookdown

  class << self

    def current_page
      Thread::current[:hookdown_current_page]
    end

    # def current_page= value
    #   Thread::current[:hookdown_current_page] = value
    # end

    def enabled? site = nil
      @site ||= site
      @enabled ||= setup
    end

    # @api private
    def reset!
      @site = nil
      @enabled = nil
    end

    private

    def setup
      enabled = if @site
        @site.config['markdown'] == 'Hookdown'
      else
        # Fallback
        Jekyll::configuration['markdown'] == 'Hookdown'
      end
      if enabled
        registry = Jekyll::Hooks.instance_variable_get :@registry
        [ :pages, :posts, :documents ].each do |owner|
          registry[owner][:post_parse] ||= [] if registry[owner]
        end
        Jekyll::Hooks::register [ :pages, :documents ], :pre_render do |page|
          Thread::current[:hookdown_current_page] = page
        end
        Jekyll::Hooks::register [ :pages, :documents ], :post_render do |page|
          if Thread::current[:hookdown_current_page] == page
            Thread::current[:hookdown_current_page] = nil
          else
            Jekyll::logger.warn JekyllIS::Hookdown::Info::NAME, "Mismatch pages: #{ page.inspect } vs #{ Thread::current[:hookdown_current_page].inspect }"
          end
        end
      end
      enabled
    end

  end

end

Jekyll::Hooks::register :site, :after_init, priority: 50 do |site|
  if JekyllIS::Hookdown::enabled?(site)
    Jekyll::logger.info JekyllIS::Hookdown::Info::NAME, 'JekyllIS::Hookdown enabled.'
  else
    Jekyll::logger.warn JekyllIS::Hookdown::Info::NAME, 'JekyllIS::Hookdown disabled.'
  end
end
