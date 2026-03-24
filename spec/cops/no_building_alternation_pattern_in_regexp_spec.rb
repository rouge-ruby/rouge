# frozen_string_literal: true

require 'rubocop'
require 'rubocop/minitest/assert_offense'
require_relative '../../lib/rubocop/cop/rouge/no_building_alternation_pattern_in_regexp.rb'

describe RuboCop::Cop::Rouge::NoBuildingAlternationPatternInRegexp do
  include RuboCop::Minitest::AssertOffense

  message = 'Rouge/NoBuildingAlternationPatternInRegexp: Avoid building alternation patterns inside a regexp. ' \
            'Use a Set lookup with a simple regex pattern for performance.'

  before do
    @cop = RuboCop::Cop::Rouge::NoBuildingAlternationPatternInRegexp.new
  end

  it 'registers an offense for .join("|") in a regexp' do
    assert_offense(<<~RUBY)
      %r/\#{keywords.join("|")}/
           ^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it "registers an offense for .join('|') in a regexp" do
    assert_offense(<<~RUBY)
      %r/\#{keywords.join('|')}/
           ^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'registers an offense for .join("|") in a complex regexp' do
    assert_offense(<<~RUBY)
      %r/\\b(\#{keywords.join("|")})\\b/
              ^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'registers an offense for chained .join("|") in a regexp' do
    assert_offense(<<~RUBY)
      %r/\#{keywords.map { |k| Regexp.escape(k) }.join("|")}/
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'registers multiple offenses for multiple .join("|") calls' do
    assert_offense(<<~RUBY)
      %r/\#{foo.join("|")}|\#{bar.join("|")}/
           ^^^^^^^^^^^^^ #{message}
                            ^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'does not register an offense for .join("|") outside a regexp' do
    assert_no_offenses(<<~'RUBY')
      keywords.join("|")
    RUBY
  end

  it 'does not register an offense for .join(",") inside a regexp' do
    assert_no_offenses(<<~'RUBY')
      %r/#{keywords.join(",")}/
    RUBY
  end

  it 'registers an offense for Regexp.union inside a regexp' do
    assert_offense(<<~RUBY)
      %r/\#{Regexp.union(keywords)}/
           ^^^^^^^^^^^^^^^^^^^^^^ #{message}
    RUBY
  end

  it 'does not register an offense for Regexp.union outside a regexp' do
    assert_no_offenses(<<~'RUBY')
      Regexp.union(keywords)
    RUBY
  end

  it 'does not register an offense for a regexp without interpolation' do
    assert_no_offenses(<<~'RUBY')
      %r/foo|bar/
    RUBY
  end
end
