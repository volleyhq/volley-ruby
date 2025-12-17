# frozen_string_literal: true

require_relative '../models/delivery_attempt'

module Volley
  module Resources
    # Delivery Attempts API resource.
    class DeliveryAttemptsResource
      def initialize(client)
        @client = client
      end

      # List delivery attempts.
      def list(project_id: nil, event_id: nil, connection_id: nil, status: nil, limit: nil, offset: nil)
        query_params = {}
        query_params['project_id'] = project_id if project_id
        query_params['event_id'] = event_id if event_id
        query_params['connection_id'] = connection_id if connection_id
        query_params['status'] = status if status
        query_params['limit'] = limit if limit
        query_params['offset'] = offset if offset

        response = @client.request('GET', '/api/delivery-attempts', query_params: query_params)

        attempts_data = response['attempts'] || []
        attempts = attempts_data.map { |attempt_data| Models::DeliveryAttempt.new(attempt_data) }

        {
          attempts: attempts,
          total: response['total'] || 0,
          limit: response['limit'] || 0,
          offset: response['offset'] || 0
        }
      end
    end
  end
end

