# -*- coding: utf-8 -*- #
require 'open-uri'
require 'json'

I18N_CONFIG_URL = 'https://raw.githubusercontent.com/cucumber/cucumber/master/gherkin/gherkin-languages.json'

module GherkinKeywords
  extend self

  def gherkin_i18n
    @gherkin_i18n ||= JSON.load(open(I18N_CONFIG_URL))
  end

  def keywords_for(*keys)
    gherkin_i18n.values.map do |lang|
      lang.values_at(*keys)
    end.flatten.compact.sort.uniq
  end

  def keywords
    @keywords ||= {
      :feature => keywords_for('feature'),
      :element => keywords_for('background', 'scenario', 'scenarioOutline'),
      :examples => keywords_for('examples'),
      :step => keywords_for('given', 'when', 'then', 'and', 'but')
    }
  end

  def source(&b)
    yield   '# -*- coding: utf-8 -*- #'
    yield   '# frozen_string_literal: true'
    yield   ''
    yield   '# automatically generated by `rake builtins:gherkin`'
    yield   '{}.tap do |k|'
    keywords.each do |t, kws|
      yield "  k[#{t.inspect}] = Set.new #{kws.inspect}"
    end
    yield   'end'
  end
end

namespace :builtins do
  task :gherkin do
    File.open('lib/rouge/lexers/gherkin/keywords.rb', 'w') do |f|
      GherkinKeywords.source { |line| f.puts line }
    end
  end
end
