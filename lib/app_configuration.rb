require "singleton"

class AppConfiguration
  include Singleton

  attr_accessor :path_to_views, :path_to_assets, :app_id, :api_key, :sponsor_pay_client

  def self.setup(&block)
    yield(instance)
  end
end
