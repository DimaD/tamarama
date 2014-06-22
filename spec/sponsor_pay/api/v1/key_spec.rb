require "spec_helper"

describe SponsorPay::API::V1::Key do
  context "when initialized with nil" do
    it do
      expect { described_class.new(nil) }.to raise_error(ArgumentError)
    end
  end

  context "when initialized with empty string" do
    it do
      expect { described_class.new("") }.to raise_error(ArgumentError)
    end
  end

  context "when initialized with non-empty string" do
    let(:api_key) { "e95a21621a1865bcbae3bee89c4d4f84" }

    subject { described_class.new(api_key) }

    it do
      expect { subject }.not_to raise_error
    end

    it "could be converted back to string" do
      expect(subject.to_s).to eq(api_key)
    end

    describe "#sign_request" do
      it "should raise error when trying to calculate signature of nil" do
        expect { subject.sign_request(nil) }.to raise_error(ArgumentError)
      end

      it "should raise error when trying to calculate signature of empty string" do
        expect { subject.sign_request("") }.to raise_error(ArgumentError)
      end

      it "should be able to calculate signature for arbitary non-empty string using SHA1" do
        expect(subject.sign_request("123")).to eq("9b15e0fa2f28bf67ff26e42d0ac47047f7662630")
      end

      it "should be able to calculate signature for object with #to_s using SHA1" do
        expect(subject.sign_request(1_000_000)).to eq("3e4e32249e8ed4853251ecbafe1ec92b448e011d")
      end
    end

    describe "#sign_response" do
      it "should raise error when trying to calculate signature of nil" do
        expect { subject.sign_response(nil) }.to raise_error(ArgumentError)
      end

      it "should raise error when trying to calculate signature of empty string" do
        expect { subject.sign_response("") }.to raise_error(ArgumentError)
      end

      it "should be able to calculate signature for arbitary non-empty string using SHA1" do
        expect(subject.sign_response("123")).to eq("50acad3e448630484ea3e6bcba98c2a6b734542d")
      end

      it "should be able to calculate signature for object with #to_s using SHA1" do
        expect(subject.sign_response(1_000_000)).to eq("e7a68df2b6dcca80ed4be3d3b683ed99bc07d9af")
      end
    end
  end
end
