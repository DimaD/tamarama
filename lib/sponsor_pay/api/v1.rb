module SponsorPay
  module API
    module V1
      def self.from_file(file)
        File.join(File.dirname(__FILE__), "v1", file)
      end

      autoload :Key,     from_file("key")
      autoload :Application,       from_file("application")
      autoload :RequestParameters, from_file("request_parameters")
      autoload :Client,  from_file("client")

      autoload :Error,                    from_file("errors")
      autoload :RequestError,             from_file("errors")
      autoload :ServerCommunicationError, from_file("errors")
      autoload :InvalidSignatureError,    from_file("errors")
      autoload :NetworkError,             from_file("errors")
      autoload :UnknownOpionalParameterError, from_file("errors")
    end
  end
end
