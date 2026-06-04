# frozen_string_literal: true

describe Rouge::Lexers::Vue do
  let(:subject) { Rouge::Lexers::Vue.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.vue'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'template attribute shorthands' do
      it 'tokenizes @ event shorthand as an attribute' do
        assert_tokens_equal '<template><button @click="handler">x</button></template>',
                            ['Name.Tag', '<'],
                            ['Keyword', 'template'],
                            ['Name.Tag', '><button'],
                            ['Text', ' '],
                            ['Name.Attribute', '@click'],
                            ['Operator', '='],
                            ['Literal.String', '"handler"'],
                            ['Name.Tag', '>'],
                            ['Text', 'x'],
                            ['Name.Tag', '</button></'],
                            ['Keyword', 'template'],
                            ['Name.Tag', '>']
      end

      it 'tokenizes @ shorthand with modifiers as an attribute' do
        assert_tokens_equal '<template><form @submit.prevent="onSubmit"></form></template>',
                            ['Name.Tag', '<'],
                            ['Keyword', 'template'],
                            ['Name.Tag', '><form'],
                            ['Text', ' '],
                            ['Name.Attribute', '@submit.prevent'],
                            ['Operator', '='],
                            ['Literal.String', '"onSubmit"'],
                            ['Name.Tag', '></form></'],
                            ['Keyword', 'template'],
                            ['Name.Tag', '>']
      end
    end
  end
end
