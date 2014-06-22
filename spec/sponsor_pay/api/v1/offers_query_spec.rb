require "spec_helper"

describe SponsorPay::API::V1::OffersQuery do
  let(:unknown_optional_parameter_error_class) { SponsorPay::API::V1::UnknownOpionalParameterError }

  describe "#query" do
    let(:http_client) { double("Mocked HttpClient") }
    subject { described_class.new(http_client) }

    it "requires to provide uid and locale" do
      expect(http_client).to receive(:get).with(anything(), include(uid: 42, locale: "en"))

      expect { subject.query(42, "en") }.not_to raise_error
    end

    it "adds timestamp to request parameters" do
      expect(http_client).to receive(:get).with(anything(), include(:timestamp))

      subject.query(42, "en")
    end

    it "allows to pass optional parameters to request" do
      expect(http_client).to receive(:get).with(anything(), include(pub0: "campaign2"))

      subject.query(42, "en", pub0: "campaign2")
    end

    it "raises UnknownOptionalParameter when passing optional parameter which is not defined in the docs" do
      expect {
        subject.query(42, "en", very_wrong_parameter_name: "does not matter")
      }.to raise_error(unknown_optional_parameter_error_class)
    end
  end
end
