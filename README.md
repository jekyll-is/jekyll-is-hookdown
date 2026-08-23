| **EN** | [ru](README-ru.md) |
|----------|----------|

# jekyll-is-hookdown

[![GitHub License](https://img.shields.io/github/license/jekyll-is/jekyll-is-hookdown)](LICENSE)
[![Gem Version](https://badge.fury.io/rb/jekyll-is-hookdown.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/jekyll-is-hookdown)
[![Ruby](https://github.com/jekyll-is/jekyll-is-hookdown/actions/workflows/ruby.yml/badge.svg)](https://github.com/jekyll-is/jekyll-is-hookdown/actions/workflows/ruby.yml)
![Coverage](coverage-badge.svg)

A Jekyll plugin that replaces the default Markdown parser with a custom one — inheriting from the standard Kramdown and extending it with an additional hook for intercepting the internal AST representation.

## Setup

In general, this gem is intended to be used by other plugins and should be listed as a dependency in *their* gemspecs, not in the site's `Gemfile`.
However, Jekyll allows writing plugins in the `_plugins` subdirectory — to use this hook there, you will need to include the gem as a plugin:

In `Gemfile`:

```ruby
group :jekyll_plugins do
    . . .
  gem 'jekyll-is-hookdown', '~> 0.8'
end
```

Or, if you are not using Bundler, install the gem manually:

```shell
gem install jekyll-is-hookdown
```

In `_config.yml`:

```yaml
plugins:
    . . .
  - jekyll-is-hookdown

markdown: Hookdown
```

The last line activates the plugin. Since the converter inherits from the standard Kramdown parser, all extensions and settings in the `kramdown` configuration subsection will continue to work (the plugin does not define its own `hookdown` section), for example:

```yaml
kramdown:
  input: GFM
  hard_wrap: false
```

### Dependencies

+ Ruby >= 3.4

+ Jekyll ~> 4.4

+ Kramdown ~> 2.5

## Usage

The main hook is injected into the [standard Jekyll hook system](https://jekyllrb.com/docs/plugins/hooks/) as the `:post_parse` event. It is available for `:pages`, `:documents`, and `:posts` (note that `:documents` *includes* `:posts`). The handler receives the page/document object and a [`Kramdown::Document`](https://kramdown.gettalong.org/rdoc/Kramdown/Document.html) instance.

```ruby
Jekyll::Hooks::register [ :pages, :documents ], :post_parse do |page, document|
  # Do something with the document...
end
```

Since in most cases you want to process specific tags/elements rather than the entire document, an additional hook is provided. It is *not* mapped to the standard Jekyll hook system and is registered differently. The handler receives the page/document object and a [`Kramdown::Element`](https://kramdown.gettalong.org/rdoc/Kramdown/Element.html) instance.

```ruby
JekyllIS::Hookdown::register_element_hook [ :pages, :documents ], :a, :img do |page, element|
  case element.type
  when :a
    # Do something here...
  when :img
    # And something here...
  end
end
```

The return value of the handler is significant and interpreted as follows:

+ `nil` — no additional action is taken.

+ `Kramdown::Element` — replaces the current element in the AST tree.

+ `:delete` — removes the current element from the AST tree.

+ Any other value is treated as an error.

_Replacing or deleting the root element (`document.root`) is not supported._

### Recommendation

If you are writing your own plugin that uses this hook, it is highly recommended to verify that it is active, i.e. that the corresponding custom converter is selected in the config. You could check the value in `_config.yml` directly, but it is better to use the dedicated method:

```ruby
if JekyllIS::Hookdown::enabled?
  # Register your hooks here...
end
```

This check will work even *before* the site is initialized.

### Example

Add `target="_blank"` to all external links:

```ruby
if JekyllIS::Hookdown::enabled?
  JekyllIS::Hookdown::register_element_hook [ :pages, :documents ], :a do |_, element|
    href = element.attr['href']
    target = element.attr['target']
    if href && !target && (href.start_with?('https://') || href.start_with?('http://'))
      element.attr['target'] = '_blank'
    end
    nil
  end
end
```

## License

The plugin is released under the **[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.html)**. This means you are free to use it without any restrictions as long as you pull it in as a dependency. If you wish to *take the code* and incorporate it into your own project, or release a *fork* of this plugin, the result must also be published under the LGPLv3.

## Status

The current version is **0.8.x**. This should be treated as a public alpha release.

However, due to the deliberately limited scope — the plugin is purely infrastructural and should not do anything extra — it is unlikely that any significant new features will be added. As tests and documentation are refined, it will gradually move to beta (0.9.x) and then to a stable release (1.0) without any substantial code changes.
