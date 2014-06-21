module SponsorPay
  module API
    module V1
      def self.from_file(file)
        File.join(File.dirname(__FILE__), "v1", file)
      end

      autoload :Key,     from_file("key")
      autoload :RequestParameters, from_file("request_parameters")
      autoload :Client,  from_file("client")
    end
  end
end