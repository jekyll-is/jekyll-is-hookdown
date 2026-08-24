# frozen_string_literal: true

require_relative 'lib/jekyll-is/hookdown/info'

Gem::Specification::new do |s|

  s.name        =   JekyllIS::Hookdown::Info::NAME
  s.version     =   JekyllIS::Hookdown::Info::VERSION
  s.summary     =   JekyllIS::Hookdown::Info::SUMMARY
  s.description =   JekyllIS::Hookdown::Info::SUMMARY + '.'
  s.authors     = [ JekyllIS::Hookdown::Info::AUTHOR   ]
  s.email       = [ JekyllIS::Hookdown::Info::EMAIL    ]
  s.homepage    =   JekyllIS::Hookdown::Info::HOMEPAGE
  s.license     =   JekyllIS::Hookdown::Info::LICENSE

  s.files = Dir[ 'lib/**/*', 'README.md', 'README-ru.md', 'LICENSE', 'coverage-badge.svg' ]

  s.required_ruby_version = '>= 3.4'

  s.add_dependency 'jekyll',   '~> 4.4'
  s.add_dependency 'kramdown', '~> 2.5'

  s.add_development_dependency 'rspec',     '~> 3.13'
  s.add_development_dependency 'rake',      '~> 13.3'
  s.add_development_dependency 'simplecov', '~> 1.1'
  s.add_development_dependency 'is-module-reset', '~> 0.8'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'yard-markdown-relative-links'

end
