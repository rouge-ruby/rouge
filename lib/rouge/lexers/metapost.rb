# -*- coding: utf-8 -*- #
# Maxime Chupin

module Rouge
  module Lexers
    class MetaPost < RegexLexer
      title "MetaPost"
      desc "MetaPost graphic language"
      tag 'metapost'
      aliases 'mp','mf','metapost','metafont'
      filenames '*.mp','*.mf'
      mimetypes 'text/x-metapost', 'application/x-metapost'


      def self.detect?(text)
        return true if text =~ /\A\s*(input|verbatimtex|def|vardef|beginfig)/
      end
      # for all variables
      id = /@?[_a-z']\w*/i

      BUILTINS            = /\b(?:
                            ahangle | ahlength |
                            bboxmargin |
                            charcode |
                            day | defaultcolormodel | defaultpen | defaultscale |
                            dotlabeldiam |
                            hour |
                            labeloffset |
                            linecap | linejoin |
                            minute | miterlimit | month | mpprocset |
                            pausing | prologues |
                            restoreclipcolor |
                            showstopping |
                            time |
                            tracingcapsules | tracingchoices | tracingcommands |
                            tracingequations | tracinglostchars | tracingmacros |
                            tracingonline | tracingoutput | tracingrestores |
                            tracingspecs | tracingstats | tracingtitles |
                            troffmode | truecorners |
                            warningcheck |
                            year |
                            filenametemplate |
                            jobname |
                            outputformat | outputtemplate |
                            background |
                            currentpen | currentpicture | cuttings |
                            defaultfont |
                            extra_beginfig | extra_endfig |
                            beveled | black | blue | bp | butt |
                            cc | cm |
                            dd | ditto | down |
                            epsilon | evenly | EOF |
                            false | fullcircle |
                            green |
                            halfcircle |
                            identity |
                            left |
                            mitered | mm | mpversion |
                            nullpen | nullpicture |
                            origin |
                            pc | pencircle | pensquare | pt |
                            quartercircle |
                            red | right | rounded |
                            squared |
                            true |
                            unitsquare | up |
                            white | withdots | of
                            )\b/x

      KEYWORDS            = /\b(?:
                            beginfig | begingroup | def | end | enddef |
                            endfig | endgroup | hide | image | input |
                            let | makepen | makepath | newinternal | primary |
                            primarydef | save | secondarydef | shipout | 
                            special | tertiarydef | vardef | 
                            else | elseif | endfor | exitif | exitunless | fi |
                            for | forever | forsuffix | if | step | until |
                            upto |
                            bot | dir | direction |
                            intersectionpoint | intiersectiontimes |
                            lft | llft | llcorner | lrcorner |
                            penoffset | point | postcontrol | precontrol |
                            rt | lrt | ulft | urt | 
                            top |
                            ulcorner | unitvector | urcorner |
                            z | bbox |
                            center | cutafter | cutbefore |
                            dashpart | dashpattern |
                            glyph |
                            infont |
                            pathpart | penpart |
                            reverse |
                            subpath |closefrom |
                            fontpart |
                            readfrom |
                            str | substring |
                            textpart  | abs | angle | arclength | arctime | ASCII |
                            blackpart | bluepart |
                            ceiling | char | colormodel | cosd | cyanpart |
                            decimal | decr | directionpoint | directiontime |
                            div | dotprod |
                            floor | fontsize |
                            greenpart | greypart |
                            hex |
                            incr |
                            length |
                            magentapart | max | mexp | min | mlog | mod |
                            normaldeviate |
                            oct |
                            redpart | round |
                            sind | sqrt |
                            uniformdeviate |
                            xpart | xxpart | xypart |
                            yellowpart | ypart | yxpart | yypart |
                             and |
                            bounded |
                            clipped |
                            filled |
                            known |
                            not |
                            odd |
                            or |
                            rgbcolor |
                            stroked |
                            textual |
                            unknown |colorpart |  also |
                            buildcycle |
                            contour | controls | cycle |
                            doublepath |
                            setbounds |
                            to |
                            whatever | label |
                            label.bot |
                            label.top |
                            label.llft |
                            label.lft |
                            label.ulft |
                            label.lrt |
                            label.rt |
                            label.urt |
                            labels |
                            labels.bot |
                            labels.top |
                            labels.llft |
                            labels.lft |
                            labels.ulft |
                            labels.lrt |
                            labels.rt |
                            labels.urt |
                            thelabel |
                            thelabel.bot |
                            thelabel.top |
                            thelabel.llft |
                            thelabel.lft |
                            thelabel.ulft |
                            thelabel.lrt |
                            thelabel.rt |
                            thelabel.urt |
                            dotlabel |
                            dotlabel.bot |
                            dotlabel.top |
                            dotlabel.llft |
                            dotlabel.lft |
                            dotlabel.ulft |
                            dotlabel.lrt |
                            dotlabel.rt |
                            dotlabel.urt | about |
                            reflected | reflectedaround |
                            rotated | rotatedabout | rotatedaround |
                            scaled | slanted | shifted |
                            transformed |
                            xscaled |
                            yscaled |
                            zscaled | addto |
                            clip | cutdraw |
                            draw | drawarrow | drawdblarrow | drawdot |
                            fill | filldraw |
                            undraw | unfill | unfilldraw | curl |
                            dashed | drawoptions |
                            pickup |
                            tension |
                            withcmykcolor | withcolor |
                            withgreyscale | withpen | withpostscript | withprescript |
                            withrgbcolor |   errhelp | errmessage |
                            fontmapfile | fontmapline |
                            interim |
                            loggingall |
                            message |
                            scantokens | show | showdependencies | showtoken | showvariable |
                            tracingall | tracingnone |
                            write to 
                            )\b/x

      TYPES               = /\b(?:
                             boolean | color | cmykcolor | expr |
                             numeric | pair | path | pen | picture |
                             string | suffix | text | transform
                            )\b/x


      PUNCTUATION         = /[\[\]{}\(\),;]/
      
      state :endstr do
        rule %r/etex/, Str, :pop!
      end
      state :string do
        rule %r/""/, Str::Escape
        rule %r/"C?/, Str, :pop!
        rule %r/[^"]+/, Str
      end

      state :root do
        rule %r/\n/, Text
        rule %r/[^\S\n]+/, Text
        rule %r/\s+/m, Text
        rule %r/%.*$/, Comment
        rule %r/[*&\[\](){}<>+=:.\/-]/, Operator
        
        # types
        rule TYPES, Keyword::Type

        # keywords
        rule %r/(interim)\b/, Keyword::Declaration
        rule KEYWORDS, Keyword

        # BUILTINS
        rule BUILTINS, Name::Builtin
        # PUNCTUATION
        rule PUNCTUATION, Other

        # strings
        rule %r/"/, Str, :string
        rule %r/verbatimtex/, Str, :endstr
        rule %r/btex/, Str, :endstr
        
        # numbers
        rule %r{((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]+))((e|E)(\+|-)?[0-9]+)?)(L|l|UL|ul|u|U|F|f|ll|LL|ull|ULL)?}, Num
        rule %r/\d+/, Literal::Number::Integer
        # rest (variable, etc)
        rule id, Name
      end
    end
  end
end