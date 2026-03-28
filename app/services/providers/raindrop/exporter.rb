module Providers
  module Raindrop
    class Exporter
      def initialize(external_account)
        @external_account = external_account
      end

      def export(article)
        client.create_bookmark(payload_for(article))
        true
      rescue TokenRefreshed
        client.create_bookmark(payload_for(article))
        true
      end

      private

      attr_reader :external_account

      def client
        @client ||= Client.new(external_account)
      end

      def payload_for(article)
        {
          link: article.url,
          title: article.title
        }.compact
      end
    end
  end
end
