module SponsorPay
  module API
    module V1
      # Umbrella error for V1 of API. If you want to write code which catches
      # all possible errors from this version of API you need to guard against
      # this class.
      class Error < StandardError
        def initialize(response=nil)
          @response = response
        end

        def message
          @response and @response.body
        end
      end

      # Errors which are raised when server replied with HTTP status 5XX
      class ServerCommunicationError < Error
      end

      # Errors which are raised when server replied with HTTP status 4XX
      class RequestError < Error
      end

      class InvalidSignatureError < Error
      end

      class UnknownOpionalParameterError < Error
        # @param parameter_name [#to_s] unknown parameter which caused error
        # @param known_parameters [Array<#to_s>] all known parameters
        def initialize(parameter_name, known_parameters)
          @parameter_name   = parameter_name
          @known_parameters = known_parameters
        end

        def message
          "Got unknown parameter #{@parameter_name.inspect}. But it is not one of the known optional parameters: #{@known_parameters.inspect}"
        end
      end

      # Errors which are raised when low level network error happens,
      # for example there is no route to host or host does not exist.
      class NetworkError < Error
        def self.basic_errors
          [
           EOFError,
           Errno::ECONNREFUSED,
           Errno::ECONNRESET,
           Errno::EHOSTUNREACH,
           Errno::EINVAL,
           Errno::EPIPE,
           Errno::ETIMEDOUT,
           Net::HTTPBadResponse,
           Net::HTTPHeaderSyntaxError,
           Net::ProtocolError,
           SocketError,
           Timeout::Error,
          ]
        end
      end
    end
  end
end
