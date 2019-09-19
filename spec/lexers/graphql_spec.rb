# frozen_string_literal: true

describe Rouge::Lexers::GraphQL do
  let(:subject) { Rouge::Lexers::GraphQL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.graphql'
      assert_guess :filename => 'bar.gql'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/graphql'
    end
  end
end
