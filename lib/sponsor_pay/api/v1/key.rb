require "digest"

module SponsorPay
  module API
    module V1
      # @private
      #
      # Key is responsible for signing requests and responses.
      class Key
        # @param str [String] String representation of API Key
        # @raise [ArgumentError] if key is not string of non-zero length
        def initialize(str)
          @key = str.to_s

          raise(ArgumentError,
                "Expected API key to be non-empty string but got: #{str.inspect}") if @key.empty?
        end

        # @param str [String] data to sign
        # @raise [ArgumentError] if input string is nil or empty
        def sign_request(str)
          sign(str, "&")
        end

        # @param body [String] response body to sign
        # @raise [ArgumentError] if body is nil or empty
        def sign_response(body)
          sign(body, "")
        end

        # @return [String]
        def to_s
          @key
        end

        protected
        # @param str [String] data to sign
        # @param separator [String] character which separates data and key when calculating signatures
        # @return [String] SHA1 signature rendered as hexademical number
        # @raise [ArgumentError] if input string is nil or empty
        def sign(str, separator)
          raise(ArgumentError, "Expected non-empty data to sign but got: #{str.inspect}") if str.to_s.empty?

          Digest::SHA1.hexdigest([str.to_s, separator, self.to_s].join)
        end

      end
    end
  end
end
