module Providers
  module Raindrop
    class Client
      include HTTParty

      base_uri "https://api.raindrop.io/rest/v1"
      headers "Content-Type" => "application/json"

      def initialize(access_token:)
        @access_token = access_token
      end

      def create_bookmark(payload)
        response = self.class.post(
          "/raindrop",
          headers: auth_headers,
          body: payload.to_json
        )

        handle_response(response)
      end

      private

      attr_reader :access_token

      def auth_headers
        {
          "Authorization" => "Bearer #{access_token}"
        }
      end

      def handle_response(response)
        case response.code
        when 200, 201
          response.parsed_response
        when 401
          raise Unauthorized, "Raindrop authorization failed"
        when 429
          raise RateLimited, "Raindrop rate limit exceeded"
        else
          raise ApiError, "Raindrop API error (status #{response.code})"
        end
      end
    end
  end
end
