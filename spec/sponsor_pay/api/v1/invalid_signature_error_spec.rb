require "spec_helper"

describe SponsorPay::API::V1::InvalidSignatureError do
  it do
    expect(subject).to be_kind_of(SponsorPay::API::V1::Error)
  end
end
