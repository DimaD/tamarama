require "digest"

module SponsorPay
  module API
    module V1
      # @private
      class Key
        # @param key [String] String representation of API Key
        # @raise [ArgumentError] if key is not string of non-zero length
        def initialize(str)
          @key = str.to_s

          raise(ArgumentError,
                "Expected API key to be non-empty string but got: #{str.inspect}") if @key.empty?
        end

        # @param str [String] data to sign
        # @return [String] SHA1 signature rendered as hexademical number
        # @rais [ArgumentError] if input string is nil or empty
        def sign(str)
          raise(ArgumentError, "Expected non-empty data to sign but got: #{str.inspect}") if str.to_s.empty?

          Digest::SHA1.hexdigest("%s&%s" % [str.to_s, @key])
        end
      end
    end
  end
end
