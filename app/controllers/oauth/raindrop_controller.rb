module Oauth
  class RaindropController < ApplicationController
    CLIENT_ID     = ENV.fetch("RAINDROP_CLIENT_ID")
    CLIENT_SECRET = ENV.fetch("RAINDROP_CLIENT_SECRET")
    REDIRECT_URI = ENV.fetch("RAINDROP_REDIRECT_URI")
    RAINDROP_TOKEN_URL = "https://raindrop.io/oauth/access_token"

    def connect
      redirect_to authorization_url, allow_other_host: true
    end

    def callback
      if params[:error].present?
        redirect_to profile_user_path(Current.user.id), alert: "Raindrop authorization was cancelled"
        return
      end

      token = exchange_code_for_token(params[:code])
      external_account = Current.user.external_accounts.find_or_initialize_by(provider: "raindrop")
      external_account.update!(
        access_token: token,
        connected_at: Time.current
      )

      redirect_to profile_user_path(Current.user.id), notice: "Raindrop connected successfully"
    rescue StandardError => e
      Rails.logger.error("Raindrop OAuth failed: #{e.message}")
      redirect_to profile_user_path(Current.user.id), alert: "Failed to connect Raindrop"
    end

    def disconnect
      Current.user.external_accounts.where(provider: "raindrop").destroy_all
      redirect_to profile_user_path(Current.user.id), notice: "Raindrop disconnected"
    end

    private

    def authorization_url
      query = {
        client_id: CLIENT_ID,
        redirect_uri: REDIRECT_URI
      }.to_query

      "https://raindrop.io/oauth/authorize?#{query}"
    end

    def exchange_code_for_token(code)
      response = HTTParty.post(
        RAINDROP_TOKEN_URL,
        headers: { "Content-Type" => "application/json" },
        body: {
          grant_type: "authorization_code",
          code: code,
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          redirect_uri: REDIRECT_URI
        }.to_json
      )

      unless response.code == 200 && response.parsed_response["access_token"]
        raise "Invalid token response from Raindrop: #{response&.body}"
      end

      response.parsed_response["access_token"]
    end
  end
end
