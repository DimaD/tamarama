require "spec_helper"

describe SponsorPay::API::V1::Client, type: :api_wrapper do
  let(:server_error_class)  { SponsorPay::API::V1::ServerCommunicationError }
  let(:request_error_class) { SponsorPay::API::V1::RequestError }
  let(:offers_query_class)  { SponsorPay::API::V1::OffersQuery }
  let(:app) { SponsorPay::API::V1::Application.new(42, "marvin") }
  let(:connection) { Faraday.new }

  subject { described_class.new(app, connection) }

  it { is_expected.to respond_to(:connection) }
  it { is_expected.to respond_to(:application) }

  describe "#offers" do
    it "proxies call to new instance of OffersQuery" do
      offers_query = double("Stubbed OffersQuery")
      expect(offers_query_class).to receive(:new).and_return(offers_query)
      expect(offers_query).to receive(:query).with(42, "de", page: 2)

      expect { subject.offers(42, "de", page: 2) }.not_to raise_error
    end
  end
end
