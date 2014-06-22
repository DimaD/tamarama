require "yaml"

_root = File.join(File.dirname(__FILE__), "..")

#
# Set up configuration
#

def load_sponsor_pay_data_from(root)
  config_path = File.join(root, "config", "sponsor_pay.yml")

  if File.exist?(config_path)
    YAML.load_file(config_path)
  else
    raise(ArgumentError, "Please put your app id and API key in config/sponsor_pay.yml")
  end
end

AppConfiguration.setup do |config|
  config.path_to_views  = File.expand_path(File.join(_root, "app", "views"))
  config.path_to_assets = File.expand_path(File.join(_root, "app", "assets"))

  sp_data = load_sponsor_pay_data_from(_root)

  config.app_id  = sp_data["app_id"]
  config.api_key = sp_data["api_key"]

  config.sponsor_pay_client = SponsorPay::API::V1.build_client(config.app_id, config.api_key)
end
