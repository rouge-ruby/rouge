# -*- coding: utf-8 -*-
# frozen_string_literal: true

describe Rouge::Lexers::Gleam do
  let(:subject) { Rouge::Lexers::Gleam.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess(filename: 'example.gleam')
    end

    it 'guesses by mimetype' do
      assert_guess(mimetype: 'text/x-gleam')
    end
  end

  describe 'lexing keywords' do
    it 'recognizes keywords' do
      %w[let fn import pub case of type as if else try opaque assert todo async await].each do |keyword|
        expect(subject.lex(keyword).to_a).to include([:keyword, keyword])
      end
    end
  end

  describe 'lexing built-in types' do
    it 'recognizes built-in types' do
      %w[Int Float Bool String List Nil Result Option Error Ok].each do |builtin|
        expect(subject.lex(builtin).to_a).to include([:keyword_type, builtin])
      end
    end
  end

  describe 'lexing constants' do
    it 'recognizes constants' do
      %w[Nil Ok Error Stop Continue True False].each do |constant|
        expect(subject.lex(constant).to_a).to include([:keyword_constant, constant])
      end
    end
  end

  describe 'lexing numbers' do
    it 'recognizes integers' do
      expect(subject.lex('42').to_a).to include([:num_integer, '42'])
    end

    it 'recognizes floating-point numbers' do
      expect(subject.lex('3.14').to_a).to include([:num_float, '3.14'])
    end

    it 'recognizes hexadecimal numbers' do
      expect(subject.lex('0x1A3F').to_a).to include([:num_hex, '0x1A3F'])
    end
  end

  describe 'lexing strings' do
    it 'recognizes double-quoted strings' do
      expect(subject.lex('"Hello, Gleam!"').to_a).to include([:str_double, '"Hello, Gleam!"'])
    end
  end

  describe 'lexing module and method calls' do
    it 'recognizes module and method calls' do
      expect(subject.lex('list.map').to_a).to include([:name_namespace, 'list'], [:punctuation, '.'], [:name_function, 'map'])
    end
  end

  describe 'lexing operators' do
    it 'recognizes pipeline operator' do
      expect(subject.lex('|>').to_a).to include([:operator, '|>'])
    end
  end
end