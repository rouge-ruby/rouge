# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::Tex do
  let(:subject) { Rouge::Formatters::Tex.new }
  let(:options) { {} }
  let(:tokens) { [] }
  let(:output) { subject.format(tokens) }
  let(:expected) { '' }

  describe 'a basic example' do
    let(:tokens) { [[Token['Name'], 'foo']] }
    let(:options) { { :wrap => false } }

    let(:expected) do
<<-'OUT'
\begin{RG*}%
\RG{n}{foo}%
\end{RG*}%
    OUT
    end

    it 'renders' do
      assert { output == expected }
    end
  end

  describe "escaping strategies" do
    # some fake code that might look like:
    #
    # foo {
    #   ~100%
    # }
    #
    # we must escape the braces, the percent sign, the tilde, 
    # and the initial space on the second line.
    let(:tokens) do
      [[Token['Keyword'], 'foo'],
       [Token['Text'], ' '],
       [Token['Punctuation'], '{'],
       [Token['Text'], "\n  "],
       [Token['Name.Constant'], '~100%'],
       [Token['Text'], "\n"],
       [Token['Punctuation'], '}'],
       [Token['Text'], "\n"]]
    end

    let(:expected) do
      <<-'OUT'
\begin{RG*}%
\RG{k}{foo}\hphantom{x}\RG{p}{\{}\newline%
\hphantom{xx}\RG{no}{{\textasciitilde}100\%}\newline%
\RG{p}{\}}%
\end{RG*}%
      OUT
    end

    it 'renders' do
      assert { output == expected }
    end
  end
end
