# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GlimmerTs do
  let(:subject) { Rouge::Lexers::GlimmerTs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gts'
      assert_guess :filename => 'component.gts'
      assert_guess :filename => 'MyComponent.gts'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gts'
      assert_guess :mimetype => 'application/x-gts'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes TypeScript code outside template blocks' do
      assert_has_token 'Keyword', 'import Component from "@glimmer/component";'
      assert_has_token 'Name.Class', 
        'export default class MyComponent extends Component {'
      assert_has_token 'Name.Decorator', '@tracked count: number = 0;'
    end

    it 'lexes TypeScript interfaces' do
      code = <<~GTS
        interface ComponentSignature {
          Element: HTMLDivElement;
          Args: {
            name: string;
            age?: number;
          };
        }
      GTS

      assert_has_token 'Keyword.Reserved', code  # interface
      assert_has_token 'Name.Other', code  # ComponentSignature
      assert_has_token 'Keyword.Reserved', code  # string, number
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

    it 'lexes complete typed class-based component' do
      code = <<~GTS
        interface MyComponentSignature {
          Args: { name: string };
        }

        export default class MyComponent extends 
          Component<MyComponentSignature> {
          @tracked count: number = 0;

          get greeting(): string {
            return `Hello, ${this.args.name}!`;
          }

          <template>
            <div>{{this.greeting}}</div>
            <p>Count: {{this.count}}</p>
            <button {{on "click" this.increment}}>+</button>
          </template>
        }
      GTS

      assert_has_token 'Keyword.Reserved', code  # interface
      assert_has_token 'Keyword', code  # export, default, class, extends, get
      assert_has_token 'Name.Class', code  # MyComponent, Component
      assert_has_token 'Name.Decorator', code  # @tracked
      assert_has_token 'Keyword.Reserved', code  # string, number
      assert_has_token 'Name.Tag', code  # <template>, <div>, <button>
      assert_has_token 'Name.Variable', code  # this.greeting, this.count
    end

    it 'lexes template-only component with signature' do
      code = <<~GTS
        import type { TOC } from '@ember/component/template-only';

        interface GreetingSignature {
          Args: { name: string; formal?: boolean };
        }

        const Greeting: TOC<GreetingSignature> = <template>
          {{#if @formal}}
            <p>Good day, {{@name}}.</p>
          {{else}}
            <p>Hey {{@name}}!</p>
          {{/if}}
        </template>;
      GTS

      assert_has_token 'Keyword', code  # import, type, const
      assert_has_token 'Keyword.Reserved', code  # interface
      assert_has_token 'Keyword.Reserved', code  # string, boolean
      assert_has_token 'Name.Tag', code  # <template>, <p>
      assert_has_token 'Name.Attribute', code  # @formal, @name
    end

    it 'lexes generic component signatures' do
      code = <<~GTS
        interface ListSignature<T> {
          Args: { items: T[]; renderItem: (item: T) => string };
        }

        export default class List<T> extends Component<ListSignature<T>> {
          <template>
            {{#each @items as |item|}}
              <div>{{@renderItem item}}</div>
            {{/each}}
          </template>
        }
      GTS

      assert_has_token 'Keyword.Reserved', code  # interface
      assert_has_token 'Name.Class', code  # List, Component
      assert_has_token 'Punctuation', code  # <, >, [, ]
      assert_has_token 'Name.Tag', code  # <template>, <div>
      assert_has_token 'Name.Attribute', code  # @items, @renderItem
    end

    it 'lexes nested handlebars expressions' do
      code = '<template>' \
             '{{#each @items as |item|}}{{item.name}}{{/each}}' \
             '</template>'
      assert_has_token 'Keyword', code  # {{#each, {{/each
      assert_has_token 'Name.Attribute', code  # @items, item.name
      assert_has_token 'Name.Tag', code  # template
    end

    it 'lexes handlebars with yield and blocks' do
      code = '<template>' \
             '<div>{{yield (hash name=@name age=@age)}}</div>' \
             '</template>'
      assert_has_token 'Keyword', code  # {{ and }}
      assert_has_token 'Name.Variable', code  # yield, hash
      assert_has_token 'Name.Attribute', code  # @name, @age
      assert_has_token 'Name.Tag', code  # template and div
    end

    it 'lexes TypeScript-specific features with templates' do
      code = <<~GTS
        type Status = 'loading' | 'success' | 'error';

        export default class StatusComponent extends Component {
          @tracked status: Status = 'loading';

          <template>
            {{#if (eq this.status "loading")}}
              <div>Loading...</div>
            {{else if (eq this.status "success")}}
              <div>Success!</div>
            {{else}}
              <div>Error occurred</div>
            {{/if}}
          </template>
        }
      GTS

      assert_has_token 'Keyword.Declaration', code  # type
      assert_has_token 'Name.Decorator', code  # @tracked
      assert_has_token 'Name.Other', code  # Status (type annotation)
      assert_has_token 'Name.Tag', code  # <template>, <div>
      assert_has_token 'Name.Variable', code  # eq (helper)
    end

    it 'lexes template boundaries correctly' do
      code = <<~GTS
        class MyComponent extends Component {
          <template>
            <div>Hello World</div>
          </template>
        }
      GTS

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

    it 'lexes mixed TypeScript and template content' do
      code = <<~GTS
        import { helper } from '@ember/component/helper';

        const formatName = helper(([first, last]: [string, string]) => 
          `${first} ${last}`);

        <template>
          <p>{{formatName @firstName @lastName}}</p>
        </template>
      GTS

      assert_has_token 'Keyword', code  # import, const
      assert_has_token 'Name.Function', code  # helper
      assert_has_token 'Keyword.Reserved', code  # string
      assert_has_token 'Name.Tag', code  # <template>, <p>
      assert_has_token 'Name.Variable', code  # formatName
      assert_has_token 'Name.Attribute', code  # @firstName, @lastName
    end
  end
end
