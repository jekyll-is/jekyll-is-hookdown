| [en](README.md) | RU |
|----------|----------|

# jekyll-is-hookdown

[![GitHub License](https://img.shields.io/github/license/jekyll-is/jekyll-is-hookdown)](LICENSE)
[![Gem Version](https://badge.fury.io/rb/jekyll-is-hookdown.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/jekyll-is-hookdown)
[![Ruby](https://github.com/jekyll-is/jekyll-is-hookdown/actions/workflows/ruby.yml/badge.svg)](https://github.com/jekyll-is/jekyll-is-hookdown/actions/workflows/ruby.yml)
![Coverage](coverage-badge.svg)

Плагин для Jekyll, позволяющий подменить markdown-парсер на кастомный — унаследованный от стандартного Kramdown и дополняющий его
дополнительным хуком для перехвата внутреннего AST-представления.

## Подключение

Вообще, гем предназначен для использования другими плагинами и должен быть указан в зависимостях именно в них, а не в `Gemfile` сайта.
Однако, в Jekyll есть возможность писать плагины в подкаталоге `_plugins` — чтобы там использовать данный хук, потребуется подключить
данный гем именно как плагин:

```ruby
group :jekyll_plugins do
  . . .
  gem 'jekyll-is-hookdown', '~> 0.8'
end
```

```yaml
plugins:
  . . .
  - jekyll-is-hookdown

markdown: Hookdown
```

Последняя строчка включает работу плагина. При этом, поскольку конвертер унаследован от стандартного Kramdown, будут работать все расширения
и настройки в подразделе конфигурации `kramdown` (собственной секции `hookdown` плагин не предусматривает), например:

```yaml
kramdown:
  input: GFM
  hard_wrap: false
```

## Использование

## Лицензия
