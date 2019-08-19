# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Formatters::HTMLLineTable do
  let(:formatter) { Rouge::Formatters::HTML.new }
  let(:options) { {} }
  let(:subject) { Rouge::Formatters::HTMLLineTable.new(formatter, options) }

  let(:output) { subject.format(input_stream) }
  let(:cell_style) do
    "-moz-user-select: none;-ms-user-select: none;-webkit-user-select: none;user-select: none;"
  end

  describe 'a simple token stream' do
    let(:input_stream) { [[Token['Name'], 'foo']] }

    it 'is formatted into a table with tagged rows' do
      expected = <<-HTML
<table class="rouge-line-table">
  <tbody>
    <tr id="line-1" class="lineno">
      <td class="rouge-gutter gl" style="#{cell_style}"><pre>1</pre></td>
      <td class="rouge-code"><pre><span class="n">foo</span>\n</pre></td>
    </tr>
  </tbody>
</table>
HTML
      expected = expected.gsub(%r{>\s+<(?!/pre)}, '><').rstrip

      assert_includes output, 'id="line-1"'
      assert { output == expected }
    end
  end

  describe 'a multiline token stream' do
    let(:input_stream) { [[Token['Text'], "foo\n"], [Token['Name'], "bar\n"], [Token['Text'], "foo\nbar"]] }

    it 'is formatted into a table-row for every newline' do
      expected = <<-HTML
<table class="rouge-line-table">
  <tbody>
    <tr id="line-1" class="lineno">
      <td class="rouge-gutter gl" style="#{cell_style}"><pre>1</pre></td>
      <td class="rouge-code"><pre>foo\n</pre></td>
    </tr>
    <tr id="line-2" class="lineno">
      <td class="rouge-gutter gl" style="#{cell_style}"><pre>2</pre></td>
      <td class="rouge-code"><pre><span class="n">bar</span>\n</pre></td>
    </tr>
    <tr id="line-3" class="lineno">
      <td class="rouge-gutter gl" style="#{cell_style}"><pre>3</pre></td>
      <td class="rouge-code"><pre>foo\n</pre></td>
    </tr>
    <tr id="line-4" class="lineno">
      <td class="rouge-gutter gl" style="#{cell_style}"><pre>4</pre></td>
      <td class="rouge-code"><pre>bar\n</pre></td>
    </tr>
  </tbody>
</table>
HTML
      expected = expected.gsub(%r{>\s+<(?!/pre)}, '><').rstrip

      assert_includes output, 'id="line-4"'
      assert { output == expected }
    end
  end

  describe 'the rendered table' do
    let(:options) do
      {
        start_line:   15,
        table_class:  'code-table',
        gutter_class: 'code-gutter',
        code_class:   'fenced-code',
        line_class:   'line-no',
        line_id:      'L%i',
      }
    end
    let(:input_stream) { [[Token['Name'], 'foo'], [Token['Text'], "bar\n"]] }

    it 'is customizable' do
      expected = <<-HTML
<table class="code-table">
  <tbody>
    <tr id="L15" class="line-no">
      <td class="code-gutter gl" style="#{cell_style}"><pre>15</pre></td>
      <td class="fenced-code">
        <pre><span class="n">foo</span>bar\n</pre>
      </td>
    </tr>
  </tbody>
</table>
HTML
      expected = expected.gsub(%r{>\s+<(?!/pre)}, '><').rstrip

      refute_includes output, 'id="L1"'
      assert { output == expected }
    end
  end
end
