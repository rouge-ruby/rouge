# frozen_string_literal: true

require 'benchmark'
require 'memory_profiler'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rouge'

class BaselineFormatter < Rouge::Formatter
  def token_lines(tokens, &block)
    return enum_for(:token_lines, tokens) unless block

    out = []
    tokens.each do |tok, val|
      val.scan %r/\n|[^\n]+/ do |segment|
        if segment == "\n"
          yield out
          out = []
        else
          out << [tok, segment]
        end
      end
    end

    yield out if out.any?
  end
end

class NewFormatter < Rouge::Formatter
  LF = "\n".b.freeze

  def token_lines(tokens, &b)
    return enum_for(:token_lines, tokens) unless block_given?

    out = []
    tokens.each do |tok, val|
      if val.valid_encoding? && val.encoding.ascii_compatible?
        bytes = val.b
        start = 0

        while (finish = bytes.index(LF, start))
          segment = val.byteslice(start...finish)
          out << [tok, segment] unless segment.empty?

          yield out
          out = []
          start = finish + LF.bytesize
        end

        segment = val.byteslice(start...)
        out << [tok, segment] unless segment.empty?
      else
        val.scan %r/\n|[^\n]+/ do |s|
          if s == "\n"
            yield out
            out = []
          else
            out << [tok, s]
          end
        end
      end
    end

    # for inputs not ending in a newline
    yield out if out.any?
  end
end

demo_dir = File.expand_path('../lib/rouge/demos', __dir__)
demo_files = Dir.glob(File.join(demo_dir, '*')).select { |path| File.file?(path) }

tokens = demo_files.map do |path|
  [Rouge::Token['Text'], File.read(path, encoding: Encoding::UTF_8)]
end

baseline_formatter = BaselineFormatter.new
new_formatter = NewFormatter.new

regexp_lines = baseline_formatter.token_lines(tokens).to_a
byte_index_lines = new_formatter.token_lines(tokens).to_a

unless regexp_lines == byte_index_lines
  raise 'implementations produced different output'
end

iterations = 100

baseline_allocations = MemoryProfiler.report do
  iterations.times do
    baseline_formatter.token_lines(tokens) { |line| line.length }
  end
end

new_allocations = MemoryProfiler.report do
  iterations.times do
    new_formatter.token_lines(tokens) { |line| line.length }
  end
end

puts "Memory allocation"
puts
puts format(
  '%-20s %10d objects %12d bytes',
  'baseline (before)',
  baseline_allocations.total_allocated,
  baseline_allocations.total_allocated_memsize
)
puts format(
  '%-20s %10d objects %12d bytes',
  'new (after)',
  new_allocations.total_allocated,
  new_allocations.total_allocated_memsize
)
puts

results = Benchmark.bmbm(24) do |benchmark|
  benchmark.report('baseline (before)') do
    iterations.times { baseline_formatter.token_lines(tokens) { |line| line.length } }
  end

  benchmark.report('new (after)') do
    iterations.times { new_formatter.token_lines(tokens) { |line| line.length } }
  end
end

puts format('Speedup: %.2fx', results[0].real / results[1].real)
