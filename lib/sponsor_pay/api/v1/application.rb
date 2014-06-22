module SponsorPay
  module API
    module V1
      # Application is responsible for providing information about
      # Application ID and Application API Key to interested parties.
      class Application
        attr_reader :id, :api_key

        # @param app_id [Object]
        # @param api_key [String] API key as string
        def initialize(app_id, api_key)
          @id = app_id
          @api_key = Key.new(api_key)
        end
      end
    end
  end
end
