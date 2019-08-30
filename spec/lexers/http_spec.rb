# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::HTTP do
  let(:subject) { Rouge::Lexers::HTTP.new }
  include Support::Lexing

  it 'lexes a HTTP/2 request' do
    request = "GET / HTTP/2"
    assert_tokens_equal request, ["Name.Function", "GET"],
                                 ["Text", " "],
                                 ["Name.Namespace", "/"],
                                 ["Text", " "],
                                 ["Keyword", "HTTP"],
                                 ["Operator", "/"],
                                 ["Literal.Number", "2"]
  end
  
  it 'lexes a HTTP/1.1 request' do
    request = "GET / HTTP/1.1"
    assert_tokens_equal request, ["Name.Function", "GET"],
                                 ["Text", " "],
                                 ["Name.Namespace", "/"],
                                 ["Text", " "],
                                 ["Keyword", "HTTP"],
                                 ["Operator", "/"],
                                 ["Literal.Number", "1.1"]
  end

  it 'lexes an empty HTTP/1.1 response' do
    response = "HTTP/1.1 200 "
    assert_tokens_equal response, ["Keyword", "HTTP"],
                                  ["Operator", "/"], 
                                  ["Literal.Number", "1.1"],
                                  ["Text", " "],
                                  ["Literal.Number", "200"],
                                  ["Text", " "]
  end
end
