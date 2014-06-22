require "faraday"

module SponsorPay
  module API
    module V1
      API_ENDPOINT = "http://api.sponsorpay.com/feed/v1/"

      # @private
      def self.from_file(file)
        File.join(File.dirname(__FILE__), "v1", file)
      end

      autoload :Key,               from_file("key")
      autoload :Application,       from_file("application")
      autoload :RequestParameters, from_file("request_parameters")
      autoload :Client,            from_file("client")
      autoload :OffersQuery,       from_file("offers_query")
      autoload :HttpClient,        from_file("http_client")

      autoload :Error,                    from_file("errors")
      autoload :RequestError,             from_file("errors")
      autoload :ServerCommunicationError, from_file("errors")
      autoload :InvalidSignatureError,    from_file("errors")
      autoload :NetworkError,             from_file("errors")
      autoload :UnknownOpionalParameterError, from_file("errors")

      # Build Instance of {V1::Client}.
      #
      # @param app_id [Object] Applciation Id
      # @param api_key [String] API key
      def self.build_client(app_id, api_key)
        Client.new(Application.new(app_id, api_key), ::Faraday.new(url: API_ENDPOINT))
      end
    end
  end
end
