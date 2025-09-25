# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Gjs do
  let(:subject) { Rouge::Lexers::Gjs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'app/components/ui/form.gjs'
      assert_guess :filename => 'app/templates/form.gjs'
      assert_guess :filename => 'tests/integration/components/ui/form-test.gjs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gjs'
      assert_guess :mimetype => 'application/x-gjs'
    end
  end
end
