require 'rouge/plugins/redcarpet'
describe Rouge::Plugins::Redcarpet do
  let(:redcarpet) {
    Class.new(Redcarpet::Render::HTML) do
      include Rouge::Plugins::Redcarpet
    end
  }

  let(:markdown) {
    Redcarpet::Markdown.new(redcarpet.new, :fenced_code_blocks => true)
  }

  it 'renders a thing' do
    result = markdown.render <<-mkd
``` javascript
var foo = 1;
```

``` shell
foo=1
```
    mkd

    assert { result.include?(%<<pre class="highlight shell">>) }
    assert { result.include?(%<<pre class="highlight javascript">>) }
  end

  it 'guesses' do
    result = markdown.render <<-mkd
``` guess
<xml>an xml code block</xml>
```
    mkd

    assert { result.include?(%<<pre class="highlight xml">>) }
  end

  it 'passes options' do
    result = markdown.render <<-mkd
``` shell?k=v
foo=1
```
    mkd

    # TODO: test that an option is actually there
    assert { result.include?(%<<pre class="highlight shell">>) }
  end

  it 'works when no language is provided' do
    result = markdown.render <<-mkd
```
#!/usr/bin/env ruby
$stdin.each { |l| $stdout.puts l.reverse }
```
    mkd
    assert { result.include?(%(<pre class="highlight ruby">)) }
  end
end
