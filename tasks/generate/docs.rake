namespace :generate do
  desc "Generate YARD documentation"
  YARD::Rake::YardocTask.new(:docs) do |t|
    t.files   = ["lib/**/*.rb", "-", "docs/*.md"]
    t.options = ["--no-private", "--protected", "--markup-provider=redcarpet",
                 "--markup=markdown"]
  end
end
