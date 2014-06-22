module SponsorPay
  module API
    module V1
      # Client class is responsible for providing facade to classes encapsulating
      # handling of different queries. This object is main entry point
      # for library consumers.
      #
      # @note
      #   Do not instantiate this class directly. Use `SponsorPay::API::V1::build_client`
      #
      # @see V1::build_client
      #
      # ## Collaborators
      #
      #   * {HttpClient}
      #   * {OffersQuery}
      class Client
        attr_reader :application, :connection

        # @param app [Application]
        # @param connection [Faraday::Connection]
        def initialize(app, connection)
          @application = app
          @connection  = connection
        end

        # @param (see OffersQuery#query)
        # @return (see OffersQuery#query)
        # @raise (see OffersQuery#query)
        def offers(uid, locale, optional_params={})
          OffersQuery.new(http_client).query(uid, locale, optional_params)
        end

        protected
        def http_client
          HttpClient.new(application, connection)
        end
      end
    end
  end
end
