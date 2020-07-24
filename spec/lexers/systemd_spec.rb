# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SystemD do
  let(:subject) { Rouge::Lexers::SystemD::new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'unit.service'
      assert_guess :filename => 'unit.socket'
      assert_guess :filename => 'unit.device'
      assert_guess :filename => 'unit.mount'
      assert_guess :filename => 'unit.automount'
      assert_guess :filename => 'unit.swap'
      assert_guess :filename => 'unit.target'
      assert_guess :filename => 'unit.path'
      assert_guess :filename => 'unit.timer'
      assert_guess :filename => 'unit.slice'
      assert_guess :filename => 'unit.scope'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-systemd-unit'
    end
  end
end
