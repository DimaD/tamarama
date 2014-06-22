require "spec_helper"

describe TamaramaApp, type: :sinatra_app do
  before :each do
    AppConfiguration.instance.sponsor_pay_client = nil

    # Freeze time so we can mock API calls on low level
    Timecop.freeze(Time.local(2014, 6, 21, 10, 12, 32))
  end

  after do
    Timecop.return
  end

  def app
    described_class
  end

  describe "/" do
    it "renders form" do
      get "/"

      expect(last_response).to be_ok
      expect_to_see_search_form
    end
  end

  describe "/search" do
    let(:hardcoded_api_parameters) do
      {
        locale: "de",
        openudid: "2b6f0cc904d137be2e1730235f5664094b831186",
        offer_types: [112],
        ip: "109.235.143.113"
      }
    end

    context "when uid is missing" do
      it "does not perform search and renders message about missing uid" do
        get "/search"

        expect(last_response).to be_ok
        expect_to_see_search_form
        expect_to_see_message_about_missing_uid
      end
    end

    context "when uid is present" do
      let(:sp_app) { SponsorPay::API::V1::Application.new(123, "testsapikey") }

      context "and API raises error" do
        let(:client) do
          sponsor_pay_client_with_mocked_offers(sp_app, hardcoded_api_parameters.merge(uid: 42)) { raise SponsorPay::API::V1::NetworkError, nil }
        end

        it "peforms search and shows message about error" do
          with_sponsor_pay_client(client) do
            get "/search", uid: "42"

            expect(last_response).to be_ok
            expect_to_see_search_form
            expect_to_see_message_about_error_during_api_call
          end
        end
      end

      context "and API returns no offers" do
        let(:client) do
          sponsor_pay_client_with_mocked_offers(sp_app, hardcoded_api_parameters.merge(uid: 42)) do
                                                  v1_no_content_response_in_json(sp_app)
                                                end
                                              end

it "peforms search and shows no offers message" do
  with_sponsor_pay_client(client) do
                                                  get "/search", uid: "42"

                                                  expect(last_response).to be_ok
                                                  expect_to_see_search_form
                                                  expect_to_see_no_offers_message
                                                end
end
      end

      context "and API returns offers" do
        let(:client) do
          sponsor_pay_client_with_mocked_offers(sp_app, hardcoded_api_parameters.merge(uid: 42)) do
            v1_successfull_response_in_json(sp_app)
          end
        end

        it "peforms search and renders offers" do
          with_sponsor_pay_client(client) do
            get "/search", uid: "42"

            expect(last_response).to be_ok
            expect_to_see_search_form
            expect_to_see_offer(" Tap  Fish")
          end
        end
      end

      context "when page and pub0 are requested as well" do
        let(:params) { Hash[uid: 42, pub0: "page2", page: "43"] }

        let(:client) do
          sponsor_pay_client_with_mocked_offers(sp_app, params.merge(hardcoded_api_parameters)) do
            v1_successfull_response_in_json(sp_app)
          end
        end

        it "they are used to query API" do
          with_sponsor_pay_client(client) do
            get "/search", params

            expect(last_response).to be_ok
            expect_to_see_search_form
            expect_to_see_offer(" Tap  Fish")
          end
        end
      end
    end
  end # describe "/search" do

  def expect_to_see_search_form
    expect(last_response.body).to match(/form/)
  end

  def expect_to_see_message_about_missing_uid
    expect(last_response.body).to match(/please specify uid/)
  end

  def expect_to_see_message_about_error_during_api_call
    expect(last_response.body).to match(/There was an error communicating with server/)
  end

  def expect_to_see_no_offers_message
    expect(last_response.body).to match(/No offers/)
  end

  def expect_to_see_offer(name)
    expect(last_response.body).to match(Regexp.new("<div class='title'>#{name}</div>"))
  end
end
