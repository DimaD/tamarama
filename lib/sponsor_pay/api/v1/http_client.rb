require "faraday"
require "json"

module SponsorPay
  module API
    module V1
      # HttpClient class is responsible for encoding and decoding requests
      #
      # ## Collaborators
      #
      #   * {Application}
      #   * Faraday::Connection
      class HttpClient
        # @param app [Application]
        # @param connection [Faraday::Connection]
        def initialize(app, connection)
          @application = app
          @connection  = connection
        end

        # Perform get request to API
        #
        # @param path [String]
        # @param parameters [Hash]
        #
        # @return [Hash] decoded response as hash
        #
        # @raise [ServerCommunicationError] if server replied with HTTP status 5XX
        # @raise [RequestError] if server replied with HTTP status 4XX
        # @raise [NetworkError] if low level network error happened
        # @raise [InvalidSignatureError] if response signature can not be verified
        def get(path, parameters)
          process_response connection.get(path, wrap(parameters).to_hash)
        rescue *NetworkError.basic_errors => e
          raise NetworkError, e
        end

        protected
        attr_reader :application, :connection

        def wrap(params)
          RequestParameters.new(params.merge(appid: application.id), application.api_key)
        end

        def process_response(response)
          case response.status
          when 200
            verify_signature response
            JSON.parse(response.body)
          when 500..599
            raise ServerCommunicationError, response
          when 400..499
            raise RequestError, response
          end
        end

        def verify_signature(response)
          signature = response.headers["X-Sponsorpay-Response-Signature"]

          if application.api_key.sign_response(response.body) != signature
            raise InvalidSignatureError, response
          else
            return true
          end
        end
      end
    end
  end
end
