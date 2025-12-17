# frozen_string_literal: true

require_relative '../models/source'

module Volley
  module Resources
    # Sources API resource.
    class SourcesResource
      def initialize(client)
        @client = client
      end

      # List all sources for a project.
      #
      # @param project_id [Integer] Project ID
      # @return [Array<Models::Source>]
      def list(project_id:)
        response = @client.request('GET', "/api/projects/#{project_id}/sources")
        sources_data = response['sources'] || []
        sources_data.map { |source_data| Models::Source.new(source_data) }
      end

      # Create a new source.
      def create(project_id:, slug:, type:, eps: nil, auth_type: nil, auth_username: nil, auth_key: nil,
                 verify_signature: nil, webhook_secret: nil)
        data = {
          'slug' => slug,
          'type' => type
        }
        data['eps'] = eps if eps
        data['auth_type'] = auth_type if auth_type
        data['auth_username'] = auth_username if auth_username
        data['auth_key'] = auth_key if auth_key
        data['verify_signature'] = verify_signature unless verify_signature.nil?
        data['webhook_secret'] = webhook_secret if webhook_secret

        response = @client.request('POST', "/api/projects/#{project_id}/sources", data: data)
        Models::Source.new(response)
      end

      # Get a source by ID.
      def get(project_id:, source_id:)
        response = @client.request('GET', "/api/projects/#{project_id}/sources/#{source_id}")
        Models::Source.new(response)
      end

      # Update a source.
      def update(project_id:, source_id:, slug: nil, eps: nil, auth_type: nil, auth_username: nil, auth_key: nil,
                 verify_signature: nil, webhook_secret: nil)
        data = {}
        data['slug'] = slug if slug
        data['eps'] = eps if eps
        data['auth_type'] = auth_type if auth_type
        data['auth_username'] = auth_username if auth_username
        data['auth_key'] = auth_key if auth_key
        data['verify_signature'] = verify_signature unless verify_signature.nil?
        data['webhook_secret'] = webhook_secret if webhook_secret

        response = @client.request('PUT', "/api/projects/#{project_id}/sources/#{source_id}", data: data)
        Models::Source.new(response)
      end

      # Delete a source.
      def delete(project_id:, source_id:)
        @client.request('DELETE', "/api/projects/#{project_id}/sources/#{source_id}")
      end
    end
  end
end

