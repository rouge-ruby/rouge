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
end
