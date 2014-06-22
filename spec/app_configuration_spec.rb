require "spec_helper"

describe AppConfiguration do
  subject { described_class.instance }

  it { is_expected.to respond_to(:path_to_views) }
  it { is_expected.to respond_to(:path_to_assets) }

  it { is_expected.to respond_to(:app_id) }
  it { is_expected.to respond_to(:api_key) }

  it { is_expected.to respond_to(:sponsor_pay_client) }
end
