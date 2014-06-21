require "spec_helper"

describe SponsorPay::API::V1::Client do
  it "need to be initialized with Application ID and API key" do
    expect {
      described_class.new(137, "e95a21621a1865bcbae3bee89c4d4f84")
    }.not_to raise_error
  end
end
