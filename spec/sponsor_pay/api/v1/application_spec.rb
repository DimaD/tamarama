require "spec_helper"

describe SponsorPay::API::V1::Application do
  context "initialized with app id and api key" do
    let(:app_id)  { 42 }
    let(:api_key) { "marvin" }

    subject { described_class.new(app_id, api_key) }

    it "should give access to app id" do
      expect(subject.id).to eq(app_id)
    end

    it "should give access to API key as instance of Key class" do
      expect(subject.api_key).to be_kind_of(SponsorPay::API::V1::Key)
      expect(subject.api_key.to_s).to eq(api_key)
    end
  end
end
