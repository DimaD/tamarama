_dir  = File.dirname(__FILE__)
_root = File.join(_dir, "..")

require "timecop"
require "rack/test"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(_dir, "support", "**/*.rb")].each {|f| require f}


RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.color = true

  config.extend Spec::FaradayStubs, type: :api_wrapper
  config.include Spec::FaradayStubs, type: :api_wrapper

  config.include Spec::SponsorPayClient, type: :sinatra_app
  config.include Rack::Test::Methods, type: :sinatra_app
end

#
# Load libraries to test
#

require File.join(_root, "lib", "sponsor_pay")
require File.join(_root, "config", "application")
