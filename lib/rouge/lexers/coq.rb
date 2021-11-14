# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Coq < RegexLexer
      title "Coq"
      desc 'Coq (coq.inria.fr)'
      tag 'coq'
      mimetypes 'text/x-coq'

      def self.gallina
        @gallina ||= Set.new %w(
          as fun if in let match then else return end Type Set Prop
          forall
        )
      end

      def self.coq
        @coq ||= Set.new %w(
          Definition Theorem Lemma Remark Example Fixpoint CoFixpoint
          Record Inductive CoInductive Corollary Goal Proof
          Ltac Require Import Export Module Section End Variable
          Context Polymorphic Monomorphic Universe Universes
          Variables Class Instance Global Local Include
          Printing Notation Infix Arguments Hint Rewrite Immediate
          Qed Defined Opaque Transparent Existing
          Compute Eval Print SearchAbout Search About Check Admitted
        )
      end

      def self.ltac
        @ltac ||= Set.new %w(
          apply eapply auto eauto rewrite setoid_rewrite
          with in as at destruct split inversion injection
          intro intros unfold fold cbv cbn lazy subst
          clear symmetry transitivity etransitivity erewrite
          edestruct constructor econstructor eexists exists
          f_equal refine instantiate revert simpl
          specialize generalize dependent red induction
          beta iota zeta delta exfalso autorewrite setoid_rewrite
          compute vm_compute native_compute
        )
      end

      def self.tacticals
        @tacticals ||= Set.new %w(
          repeat first try
        )
      end

      def self.terminators
        @terminators ||= Set.new %w(
          omega solve congruence reflexivity exact
          assumption eassumption
        )
      end

      def self.end_sentence
        @end_sentence ||= Punctuation::Indicator
      end

      def self.classify(x)
        if self.coq.include? x
          return Keyword
        elsif self.gallina.include? x
          return Keyword::Reserved
        elsif self.ltac.include? x
          return Keyword::Pseudo
        elsif self.terminators.include? x
          return Name::Exception
        elsif self.tacticals.include? x
          return Keyword::Pseudo
        else
          return Name::Constant
        end
      end

      # https://github.com/coq/coq/blob/110921a449fcb830ec2a1cd07e3acc32319feae6/clib/unicode.ml#L67
      # https://coq.inria.fr/refman/language/core/basic.html#grammar-token-ident
      id_first = /\p{L}/
      id_first_underscore = /(?:\p{L}|_)/
      id_subsequent = /(?:\p{L}|\p{N}|_|')/ # a few missing? some mathematical ' primes and subscripts
      id = /(?:#{id_first}#{id_subsequent}*)|(?:#{id_first_underscore}#{id_subsequent}+)/i
      dot_id = /\.(#{id})/i
      dot_space = /\.(\s+)/
      proof = /Proof(\s*).(\s+)/i
      qed = /(Qed|Defined|Save|Admitted)(\s*).(\s+)/i
      module_type = /Module(\s+)Type(\s+)/
      set_options = /(Set|Unset)(\s+)(Universe|Printing|Implicit|Strict)(\s+)(Polymorphism|All|Notations|Arguments|Universes|Implicit)(\s*)\./m

      state :root do
        mixin :begin_proof
        mixin :sentence
      end

      state :sentence do
        mixin :comment_whitespace
        mixin :module_setopts
        # After parsing the id, end up in sentence_postid
        rule id do |m|
          @name = m[0]
          @id_dotted = false
          push :sentence_postid
          push :continue_id
        end
      end

      state :begin_proof do
        rule proof do |m|
          token Keyword, "Proof"
          token Text::Whitespace, m[1]
          token Punctuation::Indicator, '.'
          token Text::Whitespace, m[2]
          push :proof_mode
        end
      end

      state :proof_mode do
        mixin :comment_whitespace
        mixin :module_setopts
        mixin :begin_proof
        rule qed do |m|
          token Keyword, m[1]
          token Text::Whitespace, m[2]
          token Punctuation::Indicator, '.'
          token Text::Whitespace, m[3]
          pop! # :proof_mode
        end
        # the whole point of parsing Proof/Qed, normally some of these will be operators
        rule %r/(?:\-+|\++|\*+)/, Punctuation
        rule %r/[{}]/, Punctuation
        # toplevel_selector
        rule %r/(!|all|par):/ do |m|
          token Keyword::Pseudo, m[1]
          token Punctuation, ':'.dup
        end
        # [named_goal]: { ... }
        rule %r/\[(\s*)(#{id})(\s*)(\])(\s*)(:)/ do |m|
          token Punctuation, '['
          token Text::Whitespace, m[1]
          token Name::Constant, m[2]
          token Text::Whitespace, m[3]
          token Punctuation, ']'.dup # without dup, you get an error when you attempt to appending to it with ':'
          token Text::Whitespace, m[5]
          token Punctuation, ':'.dup
        end
        # After parsing the id, end up in sentence_postid
        rule id do |m|
          @name = m[0]
          @id_dotted = false
          push :sentence_postid
          push :continue_id
        end
      end

      state :comment_whitespace do
        rule %r/[(][*](?![)])/, Comment, :comment
        rule %r/\s+/m, Text::Whitespace
      end

      state :module_setopts do
        rule module_type do |m|
          token Keyword , 'Module'
          token Text::Whitespace , m[1]
          token Keyword , 'Type'
          token Text::Whitespace , m[2]
        end
        rule set_options do |m|
          token Keyword , m[1]
          i = 2
          while m[i] != ''
            token Text::Whitespace , m[i]
            token Keyword , m[i+1]
            i += 2
          end
          token self.class.end_sentence , '.'
        end
      end

      state :sentence_postid do
        mixin :comment_whitespace
        mixin :module_setopts

        # up here to beat the id rule for lambda
        rule %r(:=|=>|;|:>|:|::|_), Punctuation
        rule %r(->|/\\|\\/|;|:>|[⇒→↔⇔≔≡∀∃∧∨¬⊤⊥⊢⊨∈λ]), Operator

        rule id do |m|
          @name = m[0]
          @id_dotted = false
          push :continue_id
        end

        # must be followed by whitespace, so that we don't match notations like sym.(a + b)
        rule %r/\.(?=\s)/, Punctuation::Indicator, :pop! # :sentence_postid

        rule %r/-?\d[\d_]*(.[\d_]*)?(e[+-]?\d[\d_]*)/i, Num::Float
        rule %r/-?\d[\d_]*/, Num::Integer

        rule %r/'(?:(\\[\\"'ntbr ])|(\\[0-9]{3})|(\\x\h{2}))'/, Str::Char
        rule %r/'/, Keyword
        rule %r/"/, Str::Double, :string
        rule %r/[~?]#{id}/, Name::Variable

        rule %r(`{|[{}\[\]()?|;,.]), Punctuation
        rule %r([!@^|~#.%/]+), Operator
        # any other combo of S (symbol), P (punctuation) and some extras just to be sure
        rule %r((?:\p{S}|\p{Pc}|[./\:\<=>\-+*])+), Operator

        rule %r/./, Error
      end

      state :comment do
        rule %r/[^(*)]+/, Comment
        rule(/[(][*]/) { token Comment; push }
        rule %r/[*][)]/, Comment, :pop!
        rule %r/[(*)]/, Comment
      end

      state :string do
        rule %r/(?:\\")+|[^"]/, Str::Double
        mixin :escape_sequence
        rule %r/\\\n/, Str::Double
        rule %r/"/, Str::Double, :pop!
      end

      state :escape_sequence do
        rule %r/\\[\\"'ntbr]/, Str::Escape
      end

      state :continue_id do
        # the stream starts with an id (stored in @name) and continues here
        rule dot_id do |m|
          token Name::Namespace , @name
          token Punctuation , '.'
          @id_dotted = true
          @name = m[1]
        end
        rule dot_space do |m|
          if @id_dotted
            token Name::Constant , @name
          else
            token self.class.classify(@name) , @name
          end
          token self.class.end_sentence , '.'
          token Text::Whitespace , m[1]
          @name = false
          @id_dotted = false
          pop! # :continue_id
          pop! # :sentence_postid
        end
        rule %r// do
          if @id_dotted
            token Name::Constant , @name
          else
            token self.class.classify(@name) , @name
          end
          @name = false
          @id_dotted = false
          # we finished parsing an id, drop back into the sentence_postid that was pushed first.
          pop! # :continue_id
        end
      end

    end
  end
end
