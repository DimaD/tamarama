# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :emacs
notification :terminal_notifier

guard :rspec, cmd: "bundle exec rspec" do
  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/sponsor_pay/(.+)/(.+)\.rb$}) { |m| "spec/sponsor_pay/#{m[1]}/#{m[2]}_spec.rb" }
  watch("lib/sponsor_pay/api/v1.rb")         { Dir["spec/sponsor_pay/api/v1/**/*.rb"] }
  watch("spec/spec_helper.rb")  { "spec" }
end
