module Providers
  module Raindrop
    class Client
      include HTTParty

      base_uri "https://api.raindrop.io/rest/v1"
      headers "Content-Type" => "application/json"

      def initialize(external_account)
        @external_account = external_account
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

      attr_reader :external_account

      def access_token
        external_account.access_token
      end

      def refresh_token
        external_account.metadata["refresh_token"]
      end

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
          refresh_and_retry(response)
        when 429
          raise RateLimited, "Raindrop rate limit exceeded"
        else
          raise ApiError, "Raindrop API error (status #{response.code})"
        end
      end

      def refresh_and_retry(response)
        return raise Unauthorized, "Raindrop authorization failed" unless refresh_token

        new_tokens = refresh_access_token!
        return raise Unauthorized, "Raindrop token refresh failed" unless new_tokens

        external_account.update!(
          access_token: new_tokens["access_token"],
          metadata: external_account.metadata.merge("refresh_token" => new_tokens["refresh_token"])
        )

        raise TokenRefreshed, "Token refreshed, retry request"
      end

      def refresh_access_token!
        response = HTTParty.post(
          "https://raindrop.io/oauth/access_token",
          headers: { "Content-Type" => "application/json" },
          body: {
            grant_type: "refresh_token",
            refresh_token: refresh_token,
            client_id: ENV.fetch("RAINDROP_CLIENT_ID"),
            client_secret: ENV.fetch("RAINDROP_CLIENT_SECRET")
          }.to_json
        )

        return nil unless response.code == 200 && response.parsed_response["access_token"]

        response.parsed_response
      end
    end
  end
end
