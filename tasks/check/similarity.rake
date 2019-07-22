def test_similarity(lexer_class)
  score, matches = Similarity.test(lexer_class)

  if score == 1
    puts "[none]"
  else
    puts "[#{score}] #{matches.map(&:tag).join(', ')}"
  end
end

namespace :check do
  desc "Test the similarity with existing lexers"
  task :similarity, [:lang] do |t, args|
    require "rouge"
    require "#{Rake.application.original_dir}/spec/support/similarity.rb"

    language = args.lang

    if language
      test_similarity Rouge::Lexer.find(language)
    else
      Rouge::Lexer.all.each do |lexer_class|
        print "#{lexer_class.tag}: "
        test_similarity lexer_class if lexer_class < Rouge::RegexLexer
      end
    end
  end
end
