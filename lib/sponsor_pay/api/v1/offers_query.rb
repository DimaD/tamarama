module SponsorPay
  module API
    module V1
      # @private
      #
      # OffersQuery is responsibility for quering data with all mandatory parameters
      # via HttpClient and checking if optional parameters are supported by API.
      #
      # {#query} method of OffersQuery is design to accept mandatory API parameters
      # as direct parameters and optional params via options hash
      class OffersQuery
        # @return [Array<Symbol>]
        KNOWN_OPTIONAL_PARAMETERS = %i(os_version ip pub0 page offer_types ps_time apple_idfa apple_idfa_tracking_enabled mac_address openudid secureudid md5_mac sha1_mac device)

        # @param client [HttpClient]
        def initialize(client)
          @http_client = client
        end

        # @param uid [#to_s] The unique User ID, as used internally in your application.
        # @param locale [String] The locale used for offer descriptions.
        # @param optional_params [Hash<Symbol, Object>] optional request parameters covered
        #                                               in API guide.
        # @return [Hash]
        #
        # @raise [UnknownOpionalParameterError] if one of the optional parameters is not
        #                                       supported by API
        # @raise [Error] if request to API caused any problems. For detailes list of errors
        #                see {HttpClient#get}.
        # @see KNOWN_OPTIONAL_PARAMETERS List of accepted keys in optional parameters.
        def query(uid, locale, optional_params={})
          raise_error_if_have_unknown_parameters(optional_params)

          http_client.get("offers.json",
                          optional_params.merge(uid:       uid,
                                                timestamp: Time.now.to_i,
                                                locale:    locale))
        end

        protected
        attr_reader :http_client

        # @param params [Hash]
        def raise_error_if_have_unknown_parameters(params)
          unknown_params = params.keys.map(&:to_sym) - KNOWN_OPTIONAL_PARAMETERS

          unless unknown_params.empty?
            raise UnknownOpionalParameterError.new(unknown_params.first, KNOWN_OPTIONAL_PARAMETERS)
          end
        end
      end
    end
  end
end
