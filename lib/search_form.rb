# SearcForm is responsible for extraction, validation and
# presentation of request params supplied via search form
class SearchForm
  def initialize(parameters)
    @params = parameters
  end

  def uid
    fetch(:uid)
  end

  def pub0
    fetch(:pub0)
  end

  def page
    if v = fetch(:page)
      page_number v
    else
      nil
    end
  end

  def optional_params
    [[:pub0, pub0],
     [:page, page]]
      .select { |k, v| !v.nil? }
      .to_h
  end

  def valid?
    !uid.nil? and !uid.to_s.empty?
  end

  protected
  attr_reader :params

  def fetch(name)
    if params[name].to_s.empty?
      nil
    else
      params[name]
    end
  end

  def page_number(str)
    if i = str.to_i and i > 0
      i
    else
      nil
    end
  end
end
