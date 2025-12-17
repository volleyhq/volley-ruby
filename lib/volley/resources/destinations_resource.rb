# frozen_string_literal: true

require_relative '../models/destination'

module Volley
  module Resources
    # Destinations API resource.
    class DestinationsResource
      def initialize(client)
        @client = client
      end

      # List all destinations for a project.
      def list(project_id:)
        response = @client.request('GET', "/api/projects/#{project_id}/destinations")
        destinations_data = response['destinations'] || []
        destinations_data.map { |destination_data| Models::Destination.new(destination_data) }
      end

      # Create a new destination.
      def create(project_id:, name:, url:, eps: nil)
        data = {
          'name' => name,
          'url' => url
        }
        data['eps'] = eps if eps

        response = @client.request('POST', "/api/projects/#{project_id}/destinations", data: data)
        Models::Destination.new(response)
      end

      # Get a destination by ID.
      def get(project_id:, destination_id:)
        response = @client.request('GET', "/api/projects/#{project_id}/destinations/#{destination_id}")
        Models::Destination.new(response)
      end

      # Update a destination.
      def update(project_id:, destination_id:, name: nil, url: nil, eps: nil)
        data = {}
        data['name'] = name if name
        data['url'] = url if url
        data['eps'] = eps if eps

        response = @client.request('PUT', "/api/projects/#{project_id}/destinations/#{destination_id}", data: data)
        Models::Destination.new(response)
      end

      # Delete a destination.
      def delete(project_id:, destination_id:)
        @client.request('DELETE', "/api/projects/#{project_id}/destinations/#{destination_id}")
      end
    end
  end
end

