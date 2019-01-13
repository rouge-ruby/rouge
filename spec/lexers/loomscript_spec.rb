# -*- coding: utf-8 -*- #

describe Rouge::Lexers::LoomScript do
  let(:subject) { Rouge::Lexers::LoomScript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ls'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/loomscript'
      assert_guess :mimetype => 'application/loomscript'
      assert_guess :mimetype => 'text/x-loomscript'
      assert_guess :mimetype => 'application/x-loomscript'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'keywords' do
      it 'identifies basic keywords' do
        tokens = subject.lex("if (_a instanceof A) return;").to_a
        assert_token_type_at(tokens, [0, 5, 10], 'Keyword')
      end

      it 'identifies constants' do
        tokens = subject.lex("function f(b:Boolean = false, n:Number = NaN, o:Object = null):void").to_a
        assert_token_type_at(tokens, [10, 19, 28], 'Keyword.Constant')
      end

      it 'identifies declarations' do
        tokens = subject.lex(
        %q(delegate ToCompute(s:String, o:Object):Number;
        public enum Enumeration {}
        struct P {
            public var x:Number = 0;
            public var y:Number = 0;
            public static operator function =(a:P, b:P):P {}
        })).to_a
        assert_token_type_at(tokens, [18, 24, 32, 45, 60, 62], 'Keyword.Declaration')
      end

      it 'identifies builtin types' do
        tokens = subject.lex("function f(b:Boolean, v:Vector.<Object>, d:Dictionary.<String, Number>):void { trace(b, v, d); }").to_a
        assert_token_type_at(tokens, [6, 11, 14, 20, 23, 26, 29], 'Keyword.Type')
      end
    end

    describe 'names' do
      it 'identifies attributes' do
        tokens = subject.lex("private static native var releaseBuild:Boolean;").to_a
        assert_token_type_at(tokens, [0, 2, 4], 'Name.Attribute')
      end
    end

  end
end
