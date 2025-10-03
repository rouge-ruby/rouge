# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Gts do
  let(:subject) { Rouge::Lexers::Gts.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'app/components/ui/form.gts'
      assert_guess :filename => 'app/templates/form.gts'
      assert_guess :filename => 'tests/integration/components/ui/form-test.gts'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gts'
      assert_guess :mimetype => 'application/x-gts'
    end
  end
end
