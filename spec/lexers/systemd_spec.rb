# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SystemD do
  let(:subject) { Rouge::Lexers::SystemD::new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'unit.service'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-systemd-unit'
    end
  end
end
