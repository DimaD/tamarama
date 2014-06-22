module Spec
  # This set of spec helpers relies on timecop gem to be used in your spec.
  # Due to the fact that OffersQuery embed timestamp of it's call time
  # to request we need some global way to "freeze" time.
  module SponsorPayClient
    include Spec::FaradayStubs

    def sponsor_pay_client_with_mocked_offers(app, params, &block)
      stubs = stub_v1_api_request("offers.json", params.merge(timestamp: Time.now.to_i), app, &block)

      SponsorPay::API::V1::Client.new(app, faraday_with_stubs(stubs))
    end

    def with_sponsor_pay_client(client, &block)
      old_client = AppConfiguration.instance.sponsor_pay_client
      AppConfiguration.instance.sponsor_pay_client = client

      block.call
    ensure
      AppConfiguration.instance.sponsor_pay_client = old_client
    end
  end
end
