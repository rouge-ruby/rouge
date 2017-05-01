# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Actionscript do
  let(:subject) { Rouge::Lexers::Actionscript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.as'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-actionscript'
      assert_guess :mimetype => 'application/x-actionscript'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'comments' do
    # Comment
    # Comment.Doc
    # Comment.Multiline
    # Comment.Preproc
    # Comment.Single
    # Comment.Special

      it 'identifies doc comments' do
        tokens = subject.lex(
        %q(/**
            Doc comment
           */)).to_a
        assert_last_token_type(tokens, 'Comment.Doc')
      end

      it 'identifies multi-line comments' do
        tokens = subject.lex(
        %q(/*
            Multi-line comment
           */)).to_a
        assert_last_token_type(tokens, 'Comment.Multiline')
      end

      it 'identifies single-line comments' do
        tokens = subject.lex('// single-line comment').to_a
        assert_last_token_type(tokens, 'Comment.Single')
      end
    end

    describe 'keywords' do
    # Keyword
    # Keyword.Constant
    # Keyword.Declaration
    # Keyword.Namespace
    # Keyword.Pseudo
    # Keyword.Reserved
    # Keyword.Type
    # Keyword.Variable

      it 'identifies basic keywords' do
        tokens = subject.lex("if (_a typeof A) return;").to_a
        assert_token_type_at(tokens, [0, 5, 10], 'Keyword')
      end

      it 'identifies constants' do
        tokens = subject.lex("function f(b:Boolean = false, n:Number = NaN, o:Object = null):void").to_a
        assert_token_type_at(tokens, [10, 19, 28], 'Keyword.Constant')
      end

      it 'identifies declarations' do
        code = <<~EOF
        public interface I {}
        public class C {}
        EOF
        tokens = subject.lex(code).to_a
        assert_token_type_at(tokens, [2, 10], 'Keyword.Declaration')
      end

      it 'identifies reserved words' do
        tokens = subject.lex("import baz.bar.foo;").to_a
        assert_first_token_type(tokens, 'Keyword.Reserved')
      end

      it 'identifies builtin types' do
        tokens = subject.lex("function f(b:Boolean, v:Vector.<Object>):void { trace(b, v); }").to_a
        assert_token_type_at(tokens, [6, 11, 14, 17], 'Keyword.Type')
      end
    end

    describe 'names' do
    # Name
    # Name.Attribute
    # Name.Builtin
    # Name.Builtin.Pseudo
    # Name.Class
    # Name.Constant
    # Name.Decorator
    # Name.Entity
    # Name.Exception
    # Name.Function
    # Name.Property
    # Name.Label
    # Name.Namespace
    # Name.Other
    # Name.Tag
    # Name.Variable
    # Name.Variable.Class
    # Name.Variable.Global
    # Name.Variable.Instance

      it 'identifies attributes' do
        tokens = subject.lex("public static const CONST:String = 'constant';").to_a
        assert_token_type_at(tokens, [0, 2], 'Name.Attribute')
      end

      it 'identifies builtin names' do
        tokens = subject.lex("if (!isNaN(parseInt(x))) { trace(x); }").to_a
        assert_token_type_at(tokens, [4, 6, 13], 'Name.Builtin')
      end

      it 'identifies labels' do
        code = <<~EOF
        switch (Math.floor(Math.random()) * 3 + 1)
        {
            case 1 : trace('rock'); break;
            case 2 : trace('paper'); break;
            default: trace('scissors'); break;
        }
        EOF
        tokens = subject.lex(code).to_a
        assert_token_type_at(tokens, [51], 'Name.Label')

        # code = <<~EOF
        # outerLoop: for (var i:int = 0; i < 10; i++)
        # {
        #     for (var j:int = 0; j < 10; j++)
        #     {
        #         if ( (i == 8) && (j == 0)) break outerLoop;
        #         trace(10 * i + j);
        #     }
        # }
        # EOF
        # tokens = subject.lex(code).to_a
        # assert { tokens[0][0] == Token['Name.Label'] }
      end
    end

    describe 'literals' do
    # Literal
    # Literal.Date
    # Literal.String
    # Literal.String.Backtick
    # Literal.String.Char
    # Literal.String.Doc
    # Literal.String.Double
    # Literal.String.Escape
    # Literal.String.Heredoc
    # Literal.String.Interpol
    # Literal.String.Other
    # Literal.String.Regex
    # Literal.String.Single
    # Literal.String.Symbol
    # Literal.Number
    # Literal.Number.Float
    # Literal.Number.Hex
    # Literal.Number.Integer
    # Literal.Number.Integer.Long
    # Literal.Number.Oct
    # Literal.Number.Bin
    # Literal.Number.Other

      it 'identifies quoted strings' do
        tokens = subject.lex(%q(var s2:String = "double-quotes with 'quotes' inside";)).to_a
        assert_token_type_at(tokens, [8], 'Literal.String.Double')

        tokens = subject.lex(%q(var s1:String = 'single-quotes with "quotes" inside';)).to_a
        assert_token_type_at(tokens, [8], 'Literal.String.Single')
      end

      it 'identifies floating point numbers' do
        tokens = subject.lex("var f:Number = 123.45;").to_a
        assert_token_type_at(tokens, [8], 'Literal.Number.Float')
      end

      it 'identifies hexadecimal numbers' do
        tokens = subject.lex("var h:Number = 0xaabbcc;").to_a
        assert_token_type_at(tokens, [8], 'Literal.Number.Hex')
      end

      it 'identifies integers' do
        tokens = subject.lex("var i:Number = 12345;").to_a
        assert_token_type_at(tokens, [8], 'Literal.Number.Integer')
      end
    end


    describe 'operators and punctuation' do
    # Operator
    # Operator.Word
    # Punctuation
    # Punctuation.Indicator

      it 'identifies bitwise operators' do
        tokens = subject.lex("var b = 1 << 3 >>> 1 & 0xff;").to_a
        assert_token_type_at(tokens, [8, 12, 16], 'Operator')
      end

      it 'identifies logical operators' do
        tokens = subject.lex("var b = (x >= 0) && (x < 1 || x == 1);").to_a
        assert_token_type_at(tokens, [9, 14, 19, 23, 27], 'Operator')
      end

      it 'identifies math operators' do
        tokens = subject.lex("var a = 5+4-3*2/1%5; a += 300; a -= 5; a *= 4; a /= 2; a %= 7;").to_a
        assert_token_type_at(tokens, [4, 7, 9, 11, 13, 15, 21, 28, 35, 42, 49], 'Operator')
      end

      it 'identifies punctuation' do
        tokens = subject.lex("var flip:Vector.<String> =  (Math.random() > 0.5) ? [a] : [z];").to_a
        assert_token_type_at(tokens, [3, 5, 12, 14, 16, 21, 23, 25, 27, 29, 31, 33], 'Punctuation')
      end
    end

  end
end
