require 'is-module-reset'

require_relative 'spec_helper'

RSpec::describe JekyllIS::Hookdown do

  def build_site processor
    config = Jekyll::configuration({
      'source' => nil,
      'destination' => nil,
      'skip_config_file' => true,
      'show_warnings' => true,
      'disable_disk_cache' => true,
      'markdown' => processor
    })
    Jekyll::Site::new(config)
  end

  it 'Not enabled by default' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      site = build_site(nil)
      expect(JekyllIS::Hookdown::enabled?(site)).to eq(false)
    end
  end

  it 'Not enabled with default processor' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      site = build_site('kramdown')
      expect(JekyllIS::Hookdown::enabled?(site)).to eq(false)
    end
  end

  it 'Enabled with Hookdown processor' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      site = build_site('Hookdown')
      expect(JekyllIS::Hookdown::enabled?(site)).to eq(true)
    end
  end

  it 'Raise error for custom event' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      build_site('markdown')
      expect do
        Jekyll::Hooks::register :pages, :post_parse do |page, document|
          # do nothing
        end
      end.to raise_error(Jekyll::Hooks::NotAvailable)
    end
  end

  it 'Do not raise error for custom event' do
    IS::ModuleReset::isolate JekyllIS::Hookdown, Jekyll do
      build_site('Hookdown')
      expect do
        Jekyll::Hooks::register :pages, :post_parse do |page, document|
          # do nothing
        end
      end.not_to raise_error
    end
  end

end
