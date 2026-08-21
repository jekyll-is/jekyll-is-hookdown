# frozen_string_literal: true

require 'jekyll'

require_relative 'info'

module JekyllIS::Hookdown

  class << self

    def apply_patch
      registry = Jekyll::Hooks.instance_variable_get :@registry
      [ :pages, :posts, :documents ].each do |owner|
        registry[owner][:post_parse] ||= [] if registry[owner]
      end
    end

    def current_page
      Thread::current[:hookdown_current_page]
    end

    def current_page= value
      Thread::current[:hookdown_current_page] = value
    end

  end

end

JekyllIS::Hookdown::apply_patch

Jekyll::Hooks::register [ :pages, :posts, :documents ], :pre_render do |page|
  JekyllIS::Hookdown::current_page = page
end
Jekyll::Hooks::register [ :pages, :posts, :documents ], :post_render do |page|
  if JekyllIS::Hookdown::current_page == page
    JekyllIS::Hookdown::current_page = nil
  else
    Jekyll::logger.warn JekyllIS::Hookdown::Info::NAME, "Mismatch pages: #{ page.inspect } vs #{ JekyllIS::Hookdown::current_page.inspect }"
  end
end
