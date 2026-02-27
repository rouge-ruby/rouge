# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::McFunction do
  let(:subject) { Rouge::Lexers::McFunction.new }

  include Support::Lexing
  it 'parses a basic command' do
    assert_no_errors 'give @s dirt'
  end
  it 'parses nbt correctly' do
    assert_no_errors '{foo: 3b, bar: 2s, quux: [0, 1, 2], compound: {hello: "world"}, list: [{a: "b"}, {c: "d", e: "f"}]}'
  end
  it 'parses selectors correctly' do
    assert_no_errors '@a[level=3..5,gamemode=!spectator,limit=5,sort=furthest,advancements={story/obtain_armor={iron_helmet=true}}]'
  end
  it 'parses execute subcommands correctly' do
    assert_no_errors 'execute as @a[nbt={SelectedItem:{id:"minecraft:dirt"}}] at @s unless block ~ ~-1 ~ dirt if block ^ ^ ^5 air run say hi'
  end
  it 'parses various things' do
    assert_no_errors 'foo:bar/quux/hello'
    assert_no_errors '#foobar'
    assert_no_errors 'scoreboard operation $foo my.objective %= * other.ob.jec.tive'
  end
end
