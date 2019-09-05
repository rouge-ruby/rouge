# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class RobotFramework < RegexLexer
      tag 'robot_framework'
      aliases 'robot' 'robot-framework'

      title "Robot Framework"
      desc 'Robot Framework is a generic open source automation testing framework (robotframework.org)'

      filenames '*.robot'
      mimetypes 'text/x-robot'
    end
  end
end
