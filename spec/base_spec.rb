require_relative 'spec_helper'

RSpec::describe JekyllIS::Hookdown do

  def build_site processor
    config = Jekyll::configuration({
      'source' => nil, # File.expand_path('/dev/null'),
      'destination' => nil, # File.expand_path('/dev/null'),
      'skip_config_file' => true,
      'show_warnings' => true,
      'markdown' => processor
    })
    Jekyll::Site::new(config)
  end

  it 'Not enabled by default' do
    JekyllIS::Hookdown::reset!
    site = build_site(nil)
    expect(JekyllIS::Hookdown::enabled?(site)).to eq(false)
  end

  it 'Not enabled with default processor' do
    JekyllIS::Hookdown::reset!
    site = build_site('kramdown')
    expect(JekyllIS::Hookdown::enabled?(site)).to eq(false)
  end

  it 'Enabled with Hookdown processor' do
    JekyllIS::Hookdown::reset!
    site = build_site('Hookdown')
    expect(JekyllIS::Hookdown::enabled?(site)).to eq(true)
  end

  it 'Do not raise error for custom event' do
    JekyllIS::Hookdown::reset!
    build_site('Hookdown')
    expect do
      Jekyll::Hooks::register :pages, :post_parse do |page, document|
        # do nothing
      end
    end.not_to raise_error
  end

end
