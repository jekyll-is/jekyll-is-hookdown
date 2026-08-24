require 'is-module-reset'

require_relative 'spec_helper'

RSpec::describe Jekyll::Converters::Markdown::Hookdown do

  it 'Main hook is triggered' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      config = Jekyll::configuration({
        'source' => nil,
        'destination' => nil,
        'skip_config_file' => true,
        'show_warnings' => true,
        'disable_disk_cache' => true,
        'markdown' => 'Hookdown'
      })
      site = Jekyll::Site::new(config)
      expect(JekyllIS::Hookdown::enabled?(site)).to eq(true)
      page = Jekyll::Page::new(site, nil, '', 'about.md')
      page.content = "# About\n\nSome text"
      page_triggered = false
      # check = true   # Хуки в Jekyll не удаляются и будут вызываться и из других тестов тоже...
      Jekyll::Hooks::register :pages, :post_parse do |page, document|
        expect(JekyllIS::Hookdown::current_page).to eq(page) # if check
        page_triggered = true
      end
      site.pages << page
      post = Jekyll::Document::new('_posts/2026-08-22-intro.md', site: site, collection: site.posts)
      post.content = "# Intro\n\nSome text"
      post_triggered = false
      Jekyll::Hooks::register :posts, :post_parse do |page, document|
        expect(JekyllIS::Hookdown::current_page).to eq(post) # if check
        post_triggered = true
      end
      site.posts.docs << post
      site.render
      expect(page_triggered).to eq(true)
      expect(post_triggered).to eq(true)
    end
  end

  it 'Special hook is triggered' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      config = Jekyll::configuration({
        'source' => nil,
        'destination' => nil,
        'skip_config_file' => true,
        'show_warnings' => true,
        'disable_disk_cache' => true,
        'markdown' => 'Hookdown'
      })
      site = Jekyll::Site::new(config)
      expect(JekyllIS::Hookdown::enabled?(site)).to eq(true)
      page_triggered = false
      post_triggered = false
      page = Jekyll::Page::new(site, nil, '', '2about.md')
      page.content = "# About\n\nSome text"
      JekyllIS::Hookdown::register_element_hook :pages, :header do |page, element|
        expect(element.type).to eq(:header)
        page_triggered = true
        nil
      end
      site.pages << page
      post = Jekyll::Document::new('_posts/2026-08-22-2intro.md', site: site, collection: site.posts)
      post.content = "# Intro\n\nSome text"
      JekyllIS::Hookdown::register_element_hook :posts, :p do |page, element|
        expect(element.type).to eq(:p)
        post_triggered = true
        nil
      end
      site.posts.docs << post
      site.render
      expect(page_triggered).to eq(true)
      expect(post_triggered).to eq(true)
    end
  end

end
