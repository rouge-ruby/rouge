# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class McFunction < RegexLexer
      title "mcfunction"
      desc "Minecraft Command Syntax"

      tag 'mcfunction'
      filenames '*.mcfunction'

      mimetypes 'text/plain'

      def self.detect?(text)
        return true if text.shebang?(/(ba|z|k)?sh/)
      end

      COMMANDS = %w(
        advancement attribute ban ban-ip banlist bossbar clear clone data datapack debug defaultgamemode deop difficulty effect
        enchant execute experience fill forceload function gamemode gamerule give help item kick kill list locate locatebiome
        loot me msg op pardon pardon-ip particle playsound publish recipe reload replaceitem save-all save-off save-on say schedule
        scoreboard seed setblock setidletimeout setworldspawn spawnpoint spectate spreadplayers stop stopsound summon tag team
        teammsg teleport tell tellraw time title tm tp trigger w weather whitelist worldborder xp
      ).map{|x| "#{x} "}.join('|')
      EXECUTE = %w(
        as at run if unless store anchored positioned rotated
      ).map{|x| "#{x} "}.join('|')
      state :root do
        # Command
        rule %r/#{COMMANDS}/, Keyword
        # Duration
        rule %r/(\d+)(t|s|d)/ do
          groups Literal::Number, Keyword::Type
        end
        # Coordinate
        rule %r/~(-?\d*(\.\d*)?)? |\^(-?\d*(\.\d*)?)? |(-?\d+(\.\d*)?) /, Literal::Number::Bin
        # Selector
        rule %r/(@[pears])(\[)/ do
          groups Literal::String::Symbol, Punctuation
          push :selector
        end
        rule %r/@[pears]/, Literal::String::Symbol
        # NBT
        rule %r/\{/ do 
          token Punctuation
          push :nbt
        end
        # Execute Modifier
        rule %r/#{EXECUTE} /, Keyword::Constant
        # Namespace / word
        rule %r/\w+:/, Name::Namespace
        rule %r/ (#|\$)\S+/, Name::Variable
        rule %r/[\w\.]+/, Name::Function
        # String
        rule %r/"(\\\\|\\"|[^"])*"/, Literal::String
        # Ops
        rule %r/\/|\.\.|[\+\-\*\/\%\^]?=|>|</, Operator
        rule %r/\*/, Keyword::Constant
        rule %r/[\[\]\,]/, Punctuation
        # Comment
        rule %r/#.+(\n|$)/, Comment
        # Whitespace
        rule %r/\s/, Text::Whitespace
      end
      state :nbt do
        rule %r/\}/, Punctuation, :pop!
        rule %r/\s/, Text::Whitespace
        rule %r/\{/ do
          token Punctuation
          push :nbt
        end
        rule %r/(\d)([bsdfBSDF])?/ do
          groups Literal::Number, Keyword::Type
        end
        rule %r/"(\\\\|\\"|[^"])*"/, Literal::String
        rule %r/'(\\\\|\\'|[^'])*'/, Literal::String
        rule %r/\[|\]|\,|:/, Punctuation
        rule %r/\w+/, Name::Property
      end
      state :selector do
        rule %r/\]/, Punctuation, :pop!
        rule %r/\s/, Text::Whitespace
        rule %r/,/, Punctuation
        rule %r/\[/ do
          token Punctuation
          push :selector
        end
        rule %r/(nbt)(=)(\{)/ do
          groups Name::Property, Operator, Punctuation
          push :nbt
        end
        rule %r/(\d+)(\.?)(\d*)?/ do
          groups Literal::Number, Punctuation, Literal::Number
        end
        rule %r/(\.)(\d+)/ do
          groups Punctuation, Literal::Number
        end
        rule %r/\.\.|!/, Operator
        rule %r/(\w+)(=)/ do
          groups Name::Property, Operator
        end
        rule %r/=/, Operator
        rule %r/\{|\}/, Punctuation
        rule %r([^\],]+), Literal::String
      end
    end
  end
end
