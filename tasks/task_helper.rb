require 'open-uri'

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, false
  yield
ensure
  $VERBOSE = old_verbose
end

class BuiltinsGenerator
  def self.process(fname, *a)
    new(*a).process(fname)
  end

  def fetch
    raise 'abstract'
  end

  def parse
    raise 'abstract'
  end

  def generate
    raise 'abstract'
  end

  def write(fname)
    FileUtils.mkdir_p(File.dirname(fname))
    File.open(fname, 'w') do |file|
      generate do |line|
        file.puts line
      end
    end
  end

  def process(fname)
    @input = fetch
    raise "failed to fetch source for #{self.class}" if @input.nil?

    @keywords = parse
    raise "failed to parse source for #{self.class}" if @keywords.nil?

    write(fname)
  end
end
