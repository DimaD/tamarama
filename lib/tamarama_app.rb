require "sinatra/base"
require "haml"

class TamaramaApp < Sinatra::Base
  configure do
    set :views, AppConfiguration.instance.path_to_views
    set :public_folder, AppConfiguration.instance.path_to_assets

    set :static, true
    set :raise_errors,    true
    set :show_exceptions, false
    enable :logging
  end


  get "/" do
    haml :index, layout: :main, locals: { form: SearchForm.new({}) }
  end

  get "/search" do
    form = SearchForm.new(params)

    offers = if form.valid?
               fetch_offers(form)
             end

    haml :search, layout: :main, locals: { form: form, offers: offers }
  end

  protected

  def sponsor_pay_client
    AppConfiguration.instance.sponsor_pay_client
  end

  def hardcoded_api_parameters
    {
      openudid: "2b6f0cc904d137be2e1730235f5664094b831186",
      offer_types: [112],
      ip: "109.235.143.113"
    }
  end

  def fetch_offers(form)
    begin
      data = sponsor_pay_client.offers(form.uid, "de", form.optional_params.merge(hardcoded_api_parameters))

      { error: nil, data: data }
    rescue SponsorPay::API::V1::Error => e
      { error: e, data: nil }
    end
  end
end
