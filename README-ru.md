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

Вообще, гем предназначен для использования другими плагинами и должен быть указан в зависимостях именно в них, а не в `Gemfile` сайта.
Однако, в Jekyll есть возможность писать плагины в подкаталоге `_plugins` — чтобы там использовать данный хук, потребуется подключить
данный гем именно как плагин:

В `Gemfile`:

```ruby
group :jekyll_plugins do
    . . .
  gem 'jekyll-is-hookdown', '~> 0.8'
end
```

В `_config.yml`:

```yaml
plugins:
    . . .
  - jekyll-is-hookdown

markdown: Hookdown
```

Последняя строчка включает работу плагина. При этом, поскольку конвертер унаследован от стандартного Kramdown, будут работать все расширения
и настройки в подразделе конфигурации `kramdown` (собственной секции `hookdown` плагин не предусматривает), например:

```yaml
kramdown:
  input: GFM
  hard_wrap: false
```

## Использование

Основной хук внедрен в общую систему хуков Jekyll как событие `:post_parse`. Он доступен для объектов `:pages`, `:documents` и `:posts` (нужно
заметить, что `:documents` _включает в себя_ `:posts`). В обработчик передается объект документа/страницы и объект класса `Kramdown::Document`.

```ruby
Jekyll::Hooks::register [ :pages, :documents ], :post_parse do |page, document|
  # Какие-то действия с документом...
end
```

Поскольку чаще всего нужно обрабатывать не весь документ, а определенные теги/элементы, предусмотрен и другой хук, не приводимый к стандартным,
он регистрируется иначе. В обработчик передается объект документа/страницы и объект класса `Kramdown::Element`.

```ruby
JekyllIS::Hookdown::register_element_hook [ :pages, :documents ], :a, :img do |page, element|
  case element.type
  when :a
    # Тут что-то делаем...
  when :img
    # И тут что-то делаем...
  end
end
```



## Лицензия

## Статус
