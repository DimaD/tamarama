
module SponsorPay
  module API
    module V1
      # @private
      class RequestParameters
        attr_reader :parameters

        # @param params [Hash<Symbol => Object>] request parameters
        # @param api_key [Key] SponsorPay API key
        # @raise [ArgumentError] if params hash or API key is empty
        def initialize(params, api_key)
          raise(ArgumentError, "Request parameters should have data") if params.empty?
          raise(ArgumentError, "Expected api_key to be kind of #{Key} but it was #{api_key.class}") unless api_key.kind_of?(Key)

          @parameters  = params
          @api_key = api_key
        end

        # @return [String] SHA1 signature rendered as hexademical number
        def signature
          @api_key.sign_request(ordered_and_concatenated_parameters)
        end

        # @return [Hash<Symbol => Object>]
        def to_hash
          parameters_with_flattened_arrays.merge(hashkey: signature)
        end

        protected
        def parameters_with_flattened_arrays
          parameters
            .to_a
            .map { |k,v| [k, v.kind_of?(Array) ? v.join(",") : v] }
            .to_h
        end

        def ordered_and_concatenated_parameters
          parameters_with_flattened_arrays
            .to_a
            .sort_by(&:first)
            .map { |parameter| "%s=%s" % parameter }
            .join("&")
        end
      end
    end
  end
end
