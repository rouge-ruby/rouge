desc "Creates all necessary files for a new lexer"
task :lex, [:language] do |t, args|
  language = args.language
  sh "touch lib/rouge/demos/#{language}"
  sh "touch spec/visual/samples/#{language}"
  sh "touch spec/lexers/#{language}_spec.rb"
  sh "touch lib/rouge/lexers/#{language}.rb"
end
