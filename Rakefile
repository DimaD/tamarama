require "yard"

desc "Generate documentation for project"
YARD::Rake::YardocTask.new("doc") do |t|
  t.files   = ["lib/**/*.rb", "-", "README.md"]
  t.options = ["--private", "--markup-provider=redcarpet", "--markup=markdown", "--output-dir=./doc/all"]
end
