# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Puppet do
  let(:subject) { Rouge::Lexers::Puppet.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      # *.pp needs source hints because it's also used by Pascal
      assert_guess :filename => 'foo.pp', :source => 'class privileges { }'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/puppet apply'
      assert_guess :source => '#!/usr/bin/puppet-apply'
    end
  end
end
