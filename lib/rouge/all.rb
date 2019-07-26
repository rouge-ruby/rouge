# -*- coding: utf-8 -*- #
# frozen_string_literal: true

Rouge::LOAD_ALL = true

require 'rouge'

Dir.glob(lexer_dir('*rb')).each { |f| Rouge::Lexers.load_lexer(f.sub(lexer_dir, '')) }
