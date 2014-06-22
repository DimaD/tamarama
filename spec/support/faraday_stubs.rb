require "faraday"

module Spec
  module FaradayStubs
    def stub_v1_api_request(path, params, app, &response)
      full_params = SponsorPay::API::V1::RequestParameters.new(params.merge(appid: app.id),
                                                               app.api_key).to_hash
      full_path   = "%s?%s" % [path, URI.encode_www_form(full_params)]

      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get(full_path, &response)
      end
    end

    def faraday_with_stubs(stubs)
      Faraday.new(url: "http://sponsorpay.local/") do |f|
        f.adapter :test, stubs
      end
    end

    def v1_no_content_response_in_json(app)
      body = <<-JSON
{
  "code": "NO_CONTENT",
  "message": "NO_CONTENT",
  "count": "1",
  "pages": "1",
  "offers" : []
}
JSON

      [200, { "X-Sponsorpay-Response-Signature" => app.api_key.sign_response(body)}, body]
    end

    def v1_unverified_response_in_json(app)
      body = <<-JSON
{
  "code": "NO_CONTENT",
  "message": "NO_CONTENT",
  "count": "1",
  "pages": "1",
  "offers" : []
}
JSON

      [200, { "X-Sponsorpay-Response-Signature" => "invalid signature"}, body]
    end

    def v1_successfull_response_in_json(app)
      body = <<-JSON
      {
        "code" :  " OK" ,
        "message":  "OK",
        "count":  "1" ,
        "pages":  "1" ,
        "information" :  {
          "app_name":  "SP Test App" ,
          "appid":  "157",
          " virtual_ currency":  "Coins",
          "country":  " US" ,
          "language":  " EN" ,
          "support_url" :  "http://iframe.sponsorpay.com/mobile/DE/157/my_offers"
        },
        "offers" :  [
                     {
                       "title":  " Tap  Fish",
                       "offer_id":  " 13554",
                       " teaser " :  "  Download and START " ,
                       " required _actions " :  "Download and START",
                       "link" :  "http://iframe.sponsorpay.com/mbrowser?appid=157&lpid=11387&uid=player1",
                       "offer_types" :  [
                                         {
                                           "offer_type_id":  "101",
                                           "readable":  "Download"
                                         },
                                         {
                                           "offer_type_id":  "112",
                                           "readable":  "Free"
                                         }
                                        ] ,
                       "thumbnail" :  {
                         "lowres" :  "http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_60.png" ,
                         "hires":  "http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_175.png"
                       },
                       "payout" :  "90",
                       "time_to_payout" :  {
                         "amount" :  "1800" ,
                         "readable":  "30 minutes"
                       }
                     }
                    ]
      }
JSON

      [200, { "X-Sponsorpay-Response-Signature" => app.api_key.sign_response(body) }, body]
    end
  end
end
