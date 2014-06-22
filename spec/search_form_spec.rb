require "spec_helper"

# For this shared example to work you need to define
# method `parameter` on your test group. For example:
#
#   let(:parameter) { :pub0 }
#
shared_examples_for "SearchForm::FetchedParameter" do
  subject { described_class.new(params).__send__(parameter) }

  context "when it is missing from params" do
    let(:params) { Hash.new }

    it { is_expected.to be_nil }
  end

  context "when it is present in params but empty" do
    let(:params) { Hash[parameter => ""] }

    it { is_expected.to be_nil }
  end

  context "when it is present in params and non-empty" do
    let(:params) { Hash[parameter => "1"] }

    it { is_expected.to eq("1") }
  end
end

describe SearchForm do
  subject { described_class.new({uid: 42, pub0: "page123"}) }

  describe "#uid" do
    let(:parameter) { :uid }

    it_should_behave_like "SearchForm::FetchedParameter"
  end

  describe "#pub0" do
    let(:parameter) { :pub0 }

    it_should_behave_like "SearchForm::FetchedParameter"
  end

  it "extracts pub0 from parameters" do
    expect(subject.pub0).to eq("page123")
  end

  describe "#page" do
    context "when page is missing from parameters" do
      it do
        expect(subject.page).to be_nil
      end
    end

    context "when page is present in parameters" do
      context "and it is an empty string" do
        subject { described_class.new({page: ""}) }

        it do
          expect(subject.page).to be_nil
        end
      end

      context "and it is a string representation of a positive number" do
        subject { described_class.new({page: "12"}) }

        it "extracts page as a number" do
          expect(subject.page).to eq(12)
        end
      end

      context "and it is a string representation of a negative number" do
        subject { described_class.new({page: "-12"}) }

        it "returns page as nil" do
          expect(subject.page).to be_nil
        end
      end

      context "and it is not a string representation of a number" do
        subject { described_class.new({page: "hello there"}) }

        it "returns page as nil" do
          expect(subject.page).to be_nil
        end
      end
    end
  end

  context "when uid is mising" do
    subject { described_class.new({}) }

    it { is_expected.not_to be_valid }
  end

  context "when uid is present" do
    context "and it is empty" do
      subject { described_class.new({uid: ""}) }

      it { is_expected.not_to be_valid}
    end

    context "and it is not empty" do
      subject { described_class.new({uid: "42"}) }

      it { is_expected.to be_valid }
    end
  end

  describe "#optional_params" do
    subject { described_class.new(params).optional_params }

    context "when pub0 and page are missing" do
      let(:params) { Hash.new }

      it { is_expected.to eq({}) }
    end

    context "when pub0 is present" do
      context "and page is missing" do
        let(:params) { Hash[pub0: "hello"] }

        it { is_expected.to eq({pub0: "hello"}) }
      end

      context "and page is present as string representation of a number" do
        let(:params) { Hash[pub0: "hello", page: "123"] }

        it { is_expected.to eq({pub0: "hello", page: 123}) }
      end

      context "and page is present but it is some text" do
        let(:params) { Hash[pub0: "hello", page: "hello too"] }

        it { is_expected.to eq({pub0: "hello"}) }
      end
    end

    context "when pub0 is missing but page is present and parsable" do
        let(:params) { Hash[page: "12"] }

        it { is_expected.to eq({page: 12}) }
    end
  end
end
