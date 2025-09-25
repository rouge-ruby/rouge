# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GlimmerJs do
  let(:subject) { Rouge::Lexers::GlimmerJs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gjs'
      assert_guess :filename => 'component.gjs'
      assert_guess :filename => 'MyComponent.gjs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gjs'
      assert_guess :mimetype => 'application/x-gjs'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes JavaScript code outside template blocks' do
      assert_has_token 'Keyword', 'import Component from "@glimmer/component";'
      assert_has_token 'Name.Class', 
        'export default class MyComponent extends Component {'
      assert_has_token 'Name.Decorator', '@tracked count = 0;'
    end

    it 'lexes template opening tag' do
      assert_tokens_equal '<template>',
        ['Name.Tag', '<template>']
    end

    it 'lexes handlebars expressions in templates' do
      code = '<template><div>{{@name}}</div></template>'
      assert_has_token 'Keyword', code  # {{ and }}
      assert_has_token 'Name.Attribute', code
      assert_has_token 'Name.Tag', code  # template and div tags
    end

    it 'lexes handlebars block helpers' do
      code = '<template>{{#if @show}}<span>visible</span>{{/if}}</template>'
      assert_has_token 'Keyword', code  # {{#if and {{/if
      assert_has_token 'Name.Attribute', code  # @show
      assert_has_token 'Name.Tag', code  # template and span tags
    end

    it 'lexes handlebars with modifiers' do
      code = '<template>' \
             '<button {{on "click" this.handleClick}}>Click</button>' \
             '</template>'
      assert_has_token 'Keyword', code  # {{ and }}
      assert_has_token 'Name.Variable', code  # on
      assert_has_token 'Literal.String.Double', code  # "click"
    end

    it 'lexes complete class-based component' do
      code = <<~GJS
        export default class MyComponent extends Component {
          @tracked count = 0;

          <template>
            <div>Count: {{this.count}}</div>
            <button {{on "click" this.increment}}>+</button>
          </template>
        }
      GJS

      assert_has_token 'Keyword', code  # export, default, class, extends
      assert_has_token 'Name.Class', code  # MyComponent, Component
      assert_has_token 'Name.Decorator', code  # @tracked
      assert_has_token 'Name.Tag', code  # <template>, <div>, <button>
      assert_has_token 'Name.Variable', code  # this.count, on
    end

    it 'lexes template-only component' do
      code = <<~GJS
        const Greeting = <template>
          <h1>Hello {{@name}}!</h1>
        </template>;
      GJS

      assert_has_token 'Keyword', code  # const
      assert_has_token 'Name.Tag', code  # <template>, <h1>
      assert_has_token 'Name.Attribute', code  # @name
    end

    it 'lexes nested handlebars expressions' do
      code = '<template>' \
             '{{#each @items as |item|}}{{item.name}}{{/each}}' \
             '</template>'
      assert_has_token 'Keyword', code  # {{#each, {{/each
      assert_has_token 'Name.Attribute', code  # @items, item.name
      assert_has_token 'Name.Tag', code  # template
    end

    it 'lexes handlebars with yield' do
      code = '<template><div>{{yield}}</div></template>'
      assert_has_token 'Keyword', code  # {{ and }}
      assert_has_token 'Name.Variable', code
      assert_has_token 'Name.Tag', code  # template and div
    end

    it 'lexes mixed JavaScript and template content' do
      code = <<~GJS
        import { helper } from '@ember/component/helper';

        const formatName = helper(([first, last]) => `${first} ${last}`);

        <template>
          <p>{{formatName @firstName @lastName}}</p>
        </template>
      GJS

      assert_has_token 'Keyword', code  # import, const
      assert_has_token 'Name.Function', code  # helper
      assert_has_token 'Name.Tag', code  # <template>, <p>
      assert_has_token 'Name.Variable', code  # formatName
      assert_has_token 'Name.Attribute', code  # @firstName, @lastName
    end

    it 'lexes template boundaries correctly' do
      code = <<~GJS
        class MyComponent extends Component {
          <template>
            <div>Hello World</div>
          </template>
        }
      GJS

      # Test that we properly enter and exit template mode
      assert_has_token 'Keyword', code  # class, extends
      assert_has_token 'Name.Tag', code  # <template>, <div>
      assert_has_token 'Text', code  # "Hello World"
    end

    it 'lexes handlebars comments' do
      code = '<template>{{! This is a comment }}<div>content</div></template>'
      assert_has_token 'Comment', code
      assert_has_token 'Name.Tag', code
    end

    it 'lexes handlebars block comments' do
      code = '<template>{{!-- Block comment --}}<div>content</div></template>'
      assert_has_token 'Comment', code
      assert_has_token 'Name.Tag', code
    end

    it 'lexes splattributes syntax' do
      code = '<template>' \
             '<div class="some-class" ...attributes>{{@someValue}}</div>' \
             '</template>'
      assert_has_token 'Operator', code  # ... operator
      assert_has_token 'Name.Attribute', code  # attributes and class
      assert_has_token 'Name.Tag', code  # div tags
      assert_has_token 'Name.Attribute', code  # @someValue
    end

    it 'lexes splattributes with other attributes' do
      code = '<template>' \
             '<button type="button" ...attributes {{on "click" @onClick}}>' \
             'Click' \
             '</button>' \
             '</template>'
      assert_has_token 'Operator', code  # ... operator
      assert_has_token 'Name.Attribute', code  # type, attributes, on
      assert_has_token 'Literal.String', code  # "button", "click"
      assert_has_token 'Keyword', code  # {{ and }}
    end

    it 'lexes splattributes in different positions' do
      code = '<template>' \
             '<input ...attributes type="text" placeholder="Enter text">' \
             '</template>'
      assert_has_token 'Operator', code  # ... operator
      assert_has_token 'Name.Attribute', code  # attributes, type, placeholder
      assert_has_token 'Literal.String', code  # "text", "Enter text"
    end
  end
end
