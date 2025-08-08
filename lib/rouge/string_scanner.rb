# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'strscan'

module Rouge
  legacy_specified = "#{ENV['ROUGE_LEGACY_ANCHORS']}" != ""

  if !legacy_specified && ::StringScanner.method_defined?(:fixed_anchor?)
    FIXED_ANCHOR = true
    def self.string_scanner(str) StringScanner.new(str, fixed_anchor: true) end
  else
    FIXED_ANCHOR = false
    def self.string_scanner(str) StringScanner.new(str) end
  end
end
