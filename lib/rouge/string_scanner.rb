# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'strscan'

module Rouge
  class << self
    legacy_specified = "#{ENV['ROUGE_LEGACY_ANCHORS']}" != ""

    if !legacy_specified && ::StringScanner.method_defined?(:fixed_anchor?)
      def fixed_anchor?; true end
      def string_scanner(str) StringScanner.new(str, fixed_anchor: true) end
    else
      def fixed_anchor?; false end
      def string_scanner(str) StringScanner.new(str) end
    end
  end
end
