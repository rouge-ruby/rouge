# -*- coding: utf-8 -*- #

module Rouge
  # A Formatter takes a token stream and formats it for human viewing.
  class Formatter
    # @private
    REGISTRY = {}

    # Specify or get the unique tag for this formatter.  This is used
    # for specifying a formatter in `rougify`.
    def self.tag(tag=nil)
      return @tag unless tag
      REGISTRY[tag] = self

      @tag = tag
    end

    # @private
    class << self
      def options
        @options ||= {}
      end
    end

    # @private
    class Option < Struct.new(:klass, :default)
    end

    # Declare a Formatter option
    def self.formatter_option(name, klass, default)
      options[name] = Option.new(klass, default)
    end

    def initialize(opts = {})
      self.class.options.each_pair do |k,o|
        v = opts.fetch(k, o.default)
        v = Theme.find(v) if o.klass.ancestors.include?(Theme) && v.is_a?(String)
        instance_variable_set("@#{k}", v)
      end
    end

    # Helper for CLI
    def set_options_from_strings(opts)
      opts.each_pair do |k,v|
        next unless self.class.options.key? k
        case
        when Symbol == self.class.options[k].klass
          v = v.to_sym
        when Fixnum == self.class.options[k].klass
          v = v.to_i
        when [ TrueClass, FalseClass ].include?(self.class.options[k].klass)
          v = %w(true on 1).include? v
        when self.class.options[k].klass.ancestors.include?(Theme)
          v = Theme.find(v)
        end
        instance_variable_set("@#{k}", v)
      end
    end

    # Define a formatter option
    def set_option(name, value)
      instance_variable_set("@#{name}", value)
    end

    # Get value of a formatter option
    def get_option(name)
      instance_variable_get("@#{name}")
    end

    # Find a formatter class given a unique tag.
    def self.find(tag)
      REGISTRY[tag]
    end

    # Format a token stream.  Delegates to {#format}.
    def self.format(tokens, opts={}, &b)
      new(opts).format(tokens, &b)
    end

    # Format a token stream.
    def format(tokens, &b)
      return stream(tokens, &b) if block_given?

      out = ''
      stream(tokens) { |piece| out << piece }

      out
    end

    # @deprecated Use {#format} instead.
    def render(tokens)
      warn 'Formatter#render is deprecated, use #format instead.'
      format(tokens)
    end

    # @abstract
    # yield strings that, when concatenated, form the formatted output
    def stream(tokens, &b)
      raise 'abstract'
    end
  end
end
