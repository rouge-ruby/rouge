# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    require_relative 'c'
    require_relative 'objective_c/common'

    class ObjectiveC < C
      extend ObjectiveCCommon

      tag 'objective_c'
      title "Objective-C"
      desc 'an extension of C commonly used to write Apple software'
      aliases 'objc', 'obj-c', 'obj_c', 'objectivec'
      filenames '*.m', '*.h'

      mimetypes 'text/x-objective_c', 'application/x-objective_c'
    end
  end
end
