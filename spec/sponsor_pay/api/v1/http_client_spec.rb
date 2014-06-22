require "spec_helper"

describe SponsorPay::API::V1::HttpClient, type: :api_wrapper do
  let(:network_error_class) { SponsorPay::API::V1::NetworkError }
  let(:server_error_class)  { SponsorPay::API::V1::ServerCommunicationError }
  let(:request_error_class) { SponsorPay::API::V1::RequestError }
  let(:invalid_signature_error_class) { SponsorPay::API::V1::InvalidSignatureError }
  let(:app) { SponsorPay::API::V1::Application.new(42, "marvin") }

  let(:connection) { faraday_with_stubs(stubs) }
  subject { described_class.new(app, connection) }

  describe "#get" do
    context "when network error happens" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { raise Errno::ECONNREFUSED }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(network_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 502 Bad Gateway" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { [502, {}, "Bad Gateway"] }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(server_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 500 Internal Server Error" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { [500, {}, "Internal Server Error"] }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(server_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 404 Not Found" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { [404, {}, "Not Found"] }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(request_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 401 Unauthorized" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { [401, {}, "Unauthorized"] }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(request_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 400 Bad Request" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { [400, {}, "Bad Request"] }
      end

      it do
        expect { subject.get("/cookies.json", {}) }.to raise_error(request_error_class)
        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 200 No Content" do
      let(:stubs) do
        stub_v1_api_request("/cookies.json", {}, app) { v1_no_content_response_in_json(app) }
      end

      it "should return response data as hash" do
        expect {
          response = subject.get("/cookies.json", {})
          expect(response).to be_kind_of(Hash)
        }.not_to raise_error

        stubs.verify_stubbed_calls
      end
    end

    context "when server responds with 200 OK" do
      context "and response is verified" do
        let(:stubs) do
          stub_v1_api_request("/cookies.json", {}, app) { v1_successfull_response_in_json(app) }
        end

        it "should return response data as hash" do
          expect {
            response = subject.get("/cookies.json", {})
            expect(response).to be_kind_of(Hash)
          }.not_to raise_error

          stubs.verify_stubbed_calls
        end
      end

      context "and response verification failed" do
        let(:stubs) do
          stub_v1_api_request("/cookies.json", {}, app) { v1_unverified_response_in_json(app) }
        end

        it "should return response data as hash" do
          expect { subject.get("/cookies.json", {}) }.to raise_error(invalid_signature_error_class)

          stubs.verify_stubbed_calls
        end
      end
    end
  end
end
