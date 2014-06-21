require "spec_helper"

describe SponsorPay::API::V1::RequestParameters do
  let(:api_key) { SponsorPay::API::V1::Key.new("e95a21621a1865bcbae3bee89c4d4f84") }

  context "when initialized with empty hash and API key" do
    it do
      expect { described_class.new({}, api_key) }.to raise_error(ArgumentError)
    end
  end

  context "when initialized with hash with data and nil API key" do
    it do
      expect { described_class.new({a: 1}, nil) }.to raise_error(ArgumentError)
    end
  end

  context "when initialized with hash with data and API key as String" do
    it do
      expect { described_class.new({a: 1}, "") }.to raise_error(ArgumentError)
    end
  end

  context "when initialized with data and non-empty API key" do
    # This case is adopted from the section of Offers API which
    # described how to calculate request signatures
    # http://developer.sponsorpay.com/content/ios/offer-wall/offer-api/#toc_25

    let(:parameters) do
      {
        appid:     157,
        uid:       "player1",
        ip:        "212.45.111.17",
        locale:    "de",
        device_id: "2b6f0cc904d137be2e1730235f5664094b831186",
        ps_time:   "1312211903",
        pub0:      "campaign2",
        page:      2,
        timestamp: 1312553361
      }
    end

    let(:expected_signature) { "7a2b1604c03d46eec1ecd4a686787b75dd693c4d" }

    subject { described_class.new(parameters, api_key) }

    it do
      expect { subject }.not_to raise_error
    end

    it "should be able to calculate signature based on all parameters and API key" do
      expect(subject.signature).to eq(expected_signature)
    end

    context "when serialized to hash" do
      it "should include all parameters" do
        expect(subject.to_hash).to include(parameters)
      end

      it "should include signature under key :hashkey" do
        expect(subject.to_hash).to include(hashkey: expected_signature)
      end
    end
  end
end
