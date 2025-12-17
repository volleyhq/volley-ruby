# frozen_string_literal: true

module Volley
  module Resources
    # Webhooks API resource.
    class WebhooksResource
      def initialize(client)
        @client = client
      end

      # Send a webhook.
      def send(source_id:, destination_id:, body:, headers: nil)
        data = {
          'source_id' => source_id,
          'destination_id' => destination_id,
          'body' => body
        }
        data['headers'] = headers if headers

        response = @client.request('POST', '/api/webhooks', data: data)
        response['message'] || 'Webhook sent'
      end
    end
  end
end

