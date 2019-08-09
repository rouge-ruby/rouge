# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::HTTP do
  let(:subject) { Rouge::Lexers::HTTP.new }
  include Support::Lexing

  it 'lexes HTTP/2' do
    request = "GET / HTTP/2"
    assert_tokens_equal request, ["Name.Function", "GET"],
                                 ["Text", " "],
                                 ["Name.Namespace", "/"],
                                 ["Text", " "],
                                 ["Keyword", "HTTP"],
                                 ["Operator", "/"],
                                 ["Literal.Number", "2"]
  end
  
  it 'lexes HTTP/1.1' do
    request = "GET / HTTP/1.1"
    assert_tokens_equal request, ["Name.Function", "GET"],
                                 ["Text", " "],
                                 ["Name.Namespace", "/"],
                                 ["Text", " "],
                                 ["Keyword", "HTTP"],
                                 ["Operator", "/"],
                                 ["Literal.Number", "1.1"]
  end
end
