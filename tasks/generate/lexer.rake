namespace :generate do
  desc "Create all necessary files for a new lexer"
  task :lexer, [:lang] do |t, args|
    language = args.lang
    sh "touch lib/rouge/demos/#{language}"
    sh "touch spec/visual/samples/#{language}"
    sh "echo \"#{lexer_template(language)}\" > lib/rouge/lexers/#{language}.rb"
    sh "echo \"#{spec_template(language)}\" > spec/lexers/#{language}_spec.rb"
  end
end

def lexer_template(language)
  <<-LEX
# frozen_string_literal: true"

module Rouge
  module Lexers
    class #{language.capitalize} < RegexLexer
      desc '#{language}'
      tag '#{language}'
      aliases '#{language}'
      filenames '*.???'

      mimetypes 'text/x-#{language}', 'application/x-#{language}'

      # a method to return true when the text unambiguously indicates
      # this language (for things like shebangs and DOCTYPE declarations)
      #
      # Please remove this method if no such indication is possible.
      def self.detect?(text)
        false
      end

      state :root do
      end
    end
  end
end
  LEX
end

def spec_template(language)
  <<-SPEC
describe Rouge::Lexers::#{language.capitalize} do
  let(:subject) { Rouge::Lexers::#{language.capitalize}.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.???'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-#{language}'
      assert_guess :mimetype => 'application/x-#{language}'
    end

    it 'guesses by source' do
      assert_guess :source => '????'
    end
  end
end
  SPEC
end
