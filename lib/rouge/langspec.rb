# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  class LangSpec
    def self.delegate(m, &default)
      define_method(m) { find_prop(m) || (default && default.call) }
    end

    def self.load_and_delegate(m)
      define_method(m) { |*a, &b| lexer_class.send(m, *a, &b) }
    end

    attr_reader :tag
    attr_reader :title
    attr_reader :desc
    attr_reader :option_docs
    attr_reader :aliases
    attr_reader :filenames
    attr_reader :mimetypes

    load_and_delegate :lex
    load_and_delegate :continue_lex
    load_and_delegate :new

    # overridden with a `def self.detect?` in
    # the cache file, but some classes don't
    # define it. this is the default implementation.
    def detect?(*)
      false
    end

    # for compat reasons, a LangSpec is considered == to the
    # lexer class itself.
    def ==(other)
      return true if super

      other.respond_to?(:tag) && other.tag == self.tag
    end

    def inspect
      "#<LangSpec:#{@const_name}>"
    end
    alias to_s inspect

    def initialize(const_name, tag, &b)
      @aliases = []
      @filenames = []
      @mimetypes = []
      @option_docs = {}

      @const_name = const_name
      @tag = tag
      instance_eval(&b)
    end

    def find_prop(prop)
      instance_variable_get("@#{prop}")
    end

    def detectable?
      @detectable
    end

    def lexer_class
      load! unless @lexer_class
      @lexer_class
    end

    def demo_file
      @demo_file ||= "lib/rouge/demos/#{tag}"
      Pathname.new(ROOT).join(@demo_file)
    end

    def demo
      File.read(demo_file, mode: 'rt:bom|utf-8')
    end

    def name
      "Rouge::Lexers::#{@const_name}"
    end

    def source_file
      "#{__dir__}/lexers/#{tag}.rb"
    end

    def load!
      LOAD_LOCK.synchronize do
        load source_file
        Lexer.lazy_constants.delete(@const_name)
        @lexer_class = Lexers.const_get(@const_name)
      end
    end
  end
end
