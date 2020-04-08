# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'strscan'

module Rouge
  class StringScanner < ::StringScanner
    def initialize(str)
      if ::StringScanner.method_defined?(:fixed_anchor?)
        super str, fixed_anchor: true
      else
        super str
      end
    end
  end
end
