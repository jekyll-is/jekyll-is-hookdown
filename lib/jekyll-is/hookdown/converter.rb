# frozen_string_literal: true

require 'jekyll'

require_relative 'setup'

# @private
class Jekyll::Converters::Markdown::Hookdown < Jekyll::Converters::Markdown::KramdownParser

  # @param [String] content
  # @return [String]
  def convert content
    document = Kramdown::JekyllDocument.new content, @config
    page = JekyllIS::Hookdown::current_page
    case page
    when Jekyll::Page
      Jekyll::Hooks::trigger :pages, :post_parse, page, document
    when Jekyll::Document
      Jekyll::Hooks::trigger :documents, :post_parse, page, document
      if page.respond_to?(:collection) && page.collection&.label == 'posts'
        Jekyll::Hooks::trigger :posts, :post_parse, page, document
      end
    else
      Jekyll::logger.warn JekyllIS::Hookdown::Info::NAME, "Unknown page type: #{ page.inspect }"
    end
    html_output = document.to_html
    if @config['show_warnings']
      document.warnings.each do |warning|
        Jekyll::logger.warn 'Kramdown warning:', warning
      end
    end
    html_output
  end

end
