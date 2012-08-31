describe Rouge::Token do
  it 'has a name' do
    assert { Rouge::Token::Text.name == 'Text' }
    assert { Rouge::Token::String.name == 'Literal.String' }
  end

  it 'can be fetched by name' do
    assert { Rouge::Token['Text'] == Rouge::Token::Text }
    assert { Rouge::Token['Literal.String'] == Rouge::Token::String }
  end

  it 'compares equal values' do
    assert { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo.Bar'] }
    deny   { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo.Baz'] }
  end

  it 'compares children' do
    assert { Rouge::Token['Foo'] === Rouge::Token['Foo.Bar'] }
    deny   { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo'] }
  end
end
