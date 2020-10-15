module SpecFocus
  FILTERED_NAMES = []
  class Focus
    def initialize(context)
      @context = context
    end

    def method_missing(name, *a, &b)
      # unnecessary because we're forwarding anyways, and we
      # *want* to be able to call private methods
      ## return super unless @context.methods.include?(name)

      res = @context.send(name, *a, &b)

      register_focus(res.to_s)
    end

  private
    def register_focus(name)
      FILTERED_NAMES << name
      ARGV.reject! { |arg| arg.start_with?('-n') }

      filter = "/\\A#{Regexp.union(FILTERED_NAMES).source}/"
      ARGV << "-n=#{filter}"
    end
  end

  module DSL
    def f
      Focus.new(self)
    end
  end
end

Minitest::Spec.send(:extend, SpecFocus::DSL)
include SpecFocus::DSL
