require 'rouge/cli'

describe Rouge::CLI do
  let(:argv) { [] }
  subject { Rouge::CLI.parse(argv) }

  describe Rouge::CLI::Help do
    describe '-h' do
      let(:argv) { %w(-h) }
      it('parses') { assert { Rouge::CLI::Help === subject } }
    end

    describe '--help' do
      let(:argv) { %w(--help) }
      it('parses') { assert { Rouge::CLI::Help === subject } }
    end

    describe 'help' do
      let(:argv) { %w(help) }
      it('parses') { assert { Rouge::CLI::Help === subject } }
    end
  end
end
