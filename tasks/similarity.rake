desc "tests the similarity with existing lexers"
task :similarity, [:language] do |t, args|
  require 'rouge'
  require "#{File.dirname(File.dirname(__FILE__))}/spec/support/similarity.rb"

  language = args.language
  lexer_class = Rouge::Lexer.find(language)

  score, matches = Similarity.test(lexer_class)

  if score == 1
    puts "No similarity found"
  else
    puts "Similarity index #{score} with #{matches.map(&:tag).join(', ')}"
  end
end
