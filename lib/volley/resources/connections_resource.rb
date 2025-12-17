# frozen_string_literal: true

require_relative '../models/connection'

module Volley
  module Resources
    # Connections API resource.
    class ConnectionsResource
      def initialize(client)
        @client = client
      end

      # Create a new connection.
      def create(project_id:, source_id:, destination_id:, status: nil, eps: nil, max_retries: nil)
        data = {
          'source_id' => source_id,
          'destination_id' => destination_id
        }
        data['status'] = status if status
        data['eps'] = eps if eps
        data['max_retries'] = max_retries if max_retries

        response = @client.request('POST', "/api/projects/#{project_id}/connections", data: data)
        Models::Connection.new(response)
      end

      # Get a connection by ID.
      def get(connection_id:)
        response = @client.request('GET', "/api/connections/#{connection_id}")
        Models::Connection.new(response)
      end

      # Update a connection.
      def update(connection_id:, status: nil, eps: nil, max_retries: nil)
        data = {}
        data['status'] = status if status
        data['eps'] = eps if eps
        data['max_retries'] = max_retries if max_retries

        response = @client.request('PUT', "/api/connections/#{connection_id}", data: data)
        Models::Connection.new(response)
      end

      # Delete a connection.
      def delete(connection_id:)
        @client.request('DELETE', "/api/connections/#{connection_id}")
      end
    end
  end
end

