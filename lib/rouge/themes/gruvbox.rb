# -*- coding: utf-8 -*- #

# TODO how are we going to handle soft/hard contrast?

module Rouge
  module Themes
    # Based on https://github.com/morhetz/gruvbox, with help from
    # https://github.com/daveyarwood/gruvbox-pygments
    class Gruvbox < CSSTheme
      name 'gruvbox'

      # global Gruvbox colours {{{
      @dark0_hard = '#1d2021'
      @dark0 ='#282828'
      @dark0_soft = '#32302f'
      @dark1 = '#3c3836'
      @dark2 = '#504945'
      @dark3 = '#665c54'
      @dark4 = '#7c6f64'
      @dark4_256 = '#7c6f64'

      @gray_245 = '#928374'
      @gray_244 = '#928374'

      @light0_hard = '#f9f5d7'
      @light0 = '#fbf1c7'
      @light0_soft = '#f2e5bc'
      @light1 = '#ebdbb2'
      @light2 = '#d5c4a1'
      @light3 = '#bdae93'
      @light4 = '#a89984'
      @light4_256 = '#a89984'

      @bright_red = '#fb4934'
      @bright_green = '#b8bb26'
      @bright_yellow = '#fabd2f'
      @bright_blue = '#83a598'
      @bright_purple = '#d3869b'
      @bright_aqua = '#8ec07c'
      @bright_orange = '#fe8019'

      @neutral_red = '#cc241d'
      @neutral_green = '#98971a'
      @neutral_yellow = '#d79921'
      @neutral_blue = '#458588'
      @neutral_purple = '#b16286'
      @neutral_aqua = '#689d6a'
      @neutral_orange = '#d65d0e'

      @faded_red = '#9d0006'
      @faded_green = '#79740e'
      @faded_yellow = '#b57614'
      @faded_blue = '#076678'
      @faded_purple = '#8f3f71'
      @faded_aqua = '#427b58'
      @faded_orange = '#af3a03'
      # }}}

      extend HasModes

      def self.light!
        mode :dark # indicate that there is a dark variant
        mode! :light
      end

      def self.dark!
        mode :light # indicate that there is a light variant
        mode! :dark
      end

      def self.make_dark!
        palette bg0: @dark0
        palette bg1: @dark1
        palette bg2: @dark2
        palette bg3: @dark3
        palette bg4: @dark4

        palette gray: @gray_245

        palette fg0: @light0
        palette fg1: @light1
        palette fg2: @light2
        palette fg3: @light3
        palette fg4: @light4

        palette fg4_256: @light4_256

        palette red: @bright_red
        palette green: @bright_green
        palette yellow: @bright_yellow
        palette blue: @bright_blue
        palette purple: @bright_purple
        palette aqua: @bright_aqua
        palette orange: @bright_orange

      end

      def self.make_light!
        palette bg0: @light0
        palette bg1: @light1
        palette bg2: @light2
        palette bg3: @light3
        palette bg4: @light4

        palette gray: @gray_244

        palette fg0: @dark0
        palette fg1: @dark1
        palette fg2: @dark2
        palette fg3: @dark3
        palette fg4: @dark4

        palette fg4_256: @dark4_256

        palette red: @faded_red
        palette green: @faded_green
        palette yellow: @faded_yellow
        palette blue: @faded_blue
        palette purple: @faded_purple
        palette aqua: @faded_aqua
        palette orange: @faded_orange
      end

      dark!

      style Text, :fg => :fg0, :bg => :bg0
      style Error, :fg => :red, :bg => :bg0, :bold => true
      style Comment, :fg => :gray, :italic => true

      style Comment::Preproc, :fg => :aqua

      style Name::Tag, :fg => :red

      style Operator,
            Punctuation, :fg => :fg0

      style Generic::Inserted, :fg => :green, :bg => :bg0
      style Generic::Deleted, :fg => :red, :bg => :bg0
      style Generic::Heading, :fg => :green, :bold => true

      style Keyword, :fg => :red
      style Keyword::Constant, :fg => :purple
      style Keyword::Type, :fg => :yellow

      style Keyword::Declaration, :fg => :orange

      style Literal::String,
            Literal::String::Interpol,
            Literal::String::Regex, :fg => :green, :italic => true

      style Literal::String::Escape, :fg => :orange

      style Name::Namespace,
            Name::Class, :fg => :aqua

      style Name::Constant, :fg => :purple

      style Name::Attribute, :fg => :green

      style Literal::Number, :fg => :purple

      style Literal::String::Symbol, :fg => :blue

    end
  end
end
