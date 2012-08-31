describe Rouge::Token do
  it 'has a name' do
    assert { Rouge::Token['Text'].name == 'Text' }
    assert { Rouge::Token['Literal.String'].name == 'Literal.String' }
  end

  it 'compares equal values' do
    assert { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo.Bar'] }
    deny   { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo.Baz'] }
  end

  it 'compares children' do
    assert { Rouge::Token['Foo'] === Rouge::Token['Foo.Bar'] }
    deny   { Rouge::Token['Foo.Bar'] === Rouge::Token['Foo'] }
  end

  it 'has shortnames' do
    assert { Rouge::Token['Name'].shortname == 'n' }
    assert { Rouge::Token['String.Backtick'].shortname == 'sb' }
  end
end
