# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Terraform do
  let(:subject) { Rouge::Lexers::Terraform.new }

  include Support::Lexing
  it 'parses a basic Terraform file' do
    tokens = subject.lex('terraform {}').to_a
    assert { tokens.size == 3 }
    assert { tokens.first[0] == Token['Keyword'] }
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tf'
      deny_guess   :filename => 'foo'
    end

    it 'guesses by mimetype' do
    end

    it 'guesses by source' do
    end
  end
end
