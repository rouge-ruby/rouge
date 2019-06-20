def test_similarity(lexer_class)
  score, matches = Similarity.test(lexer_class)

  if score == 1
    puts "[none]"
  else
    puts "[#{score}] #{matches.map(&:tag).join(', ')}"
  end
end

desc "tests the similarity with existing lexers"
task :similarity, [:language] do |t, args|
  require 'rouge'
  require "#{File.dirname(__dir__)}/spec/support/similarity.rb"

  language = args.language

  if language
    test_similarity Rouge::Lexer.find(language)
  else
    Rouge::Lexer.all.each do |lexer_class|
      print "#{lexer_class.tag}: "
      test_similarity lexer_class if lexer_class < Rouge::RegexLexer
    end
  end
end
