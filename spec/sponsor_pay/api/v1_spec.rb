require "spec_helper"

describe SponsorPay::API::V1, "::build_client" do
  subject { described_class::build_client(42, "marvin") }

  it "returns new instance of Client" do
    expect(subject).to be_kind_of(SponsorPay::API::V1::Client)
  end

  it "returns new instance of Client which uses connection pointing to official API endpoint" do
    expect(subject.connection.url_prefix.to_s).to eq("http://api.sponsorpay.com/feed/v1/")
  end
end
