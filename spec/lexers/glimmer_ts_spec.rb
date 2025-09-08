# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GlimmerTs do
  let(:subject) { Rouge::Lexers::GlimmerTs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gts'
      assert_guess :filename => 'component.gts'
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
      assert_has_token 'Name.Class', 'export default class MyComponent extends Component {'
    end

    it 'lexes TypeScript interfaces' do
      code = <<~GTS
        interface Args {
          name: string;
        }
        
        export default class MyComponent extends Component<Args> {
          <template>
            <div>Hello {{@name}}</div>
          </template>
        }
      GTS
      
      assert_has_token 'Keyword.Declaration', code
      assert_has_token 'Name.Tag', code
    end

    it 'lexes template blocks' do
      code = <<~GTS
        export default class MyComponent extends Component {
          <template>
            <div>Hello {{@name}}</div>
          </template>
        }
      GTS
      
      assert_has_token 'Name.Tag', code
      assert_has_token 'Keyword', code  # Handlebars uses Keyword for {{ and }}
    end
  end
end
