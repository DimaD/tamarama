require "spec_helper"

describe SponsorPay::API::V1::UnknownOpionalParameterError do
  subject { described_class.new(:ip_address, [:ip]) }

  it do
    expect(subject).to be_kind_of(SponsorPay::API::V1::Error)
  end

  it "mentions unkown parameter in error message" do
    expect(subject.message).to match(/:ip_address/)
  end

  it "mentions list of known parameters in error message" do
    expect(subject.message).to match(/\[:ip\]/)
  end

end
