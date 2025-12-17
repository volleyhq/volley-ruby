# frozen_string_literal: true

require_relative '../models/organization'

module Volley
  module Resources
    # Organizations API resource.
    class OrganizationsResource
      def initialize(client)
        @client = client
      end

      # List all organizations the user has access to.
      #
      # @return [Array<Models::Organization>]
      def list
        response = @client.request('GET', '/api/org/list')
        orgs_data = response['organizations'] || []
        orgs_data.map { |org_data| Models::Organization.new(org_data) }
      end

      # Get the current organization.
      #
      # @param organization_id [Integer, nil] Optional organization ID. If nil, uses default organization.
      # @return [Models::Organization]
      def get(organization_id: nil)
        original_org_id = @client.get_organization_id
        @client.set_organization_id(organization_id) if organization_id

        begin
          response = @client.request('GET', '/api/org')
          # GetOrganization returns id, name, slug, role (not account_id, created_at)
          org_data = {
            'id' => response['id'],
            'name' => response['name'],
            'slug' => response['slug'],
            'role' => response['role'],
            'account_id' => response['account_id'],
            'created_at' => response['created_at']
          }
          Models::Organization.new(org_data)
        ensure
          if original_org_id
            @client.set_organization_id(original_org_id)
          else
            @client.clear_organization_id
          end
        end
      end

      # Create a new organization.
      #
      # @param name [String] Organization name
      # @return [Models::Organization]
      def create(name:)
        data = { 'name' => name }
        response = @client.request('POST', '/api/org', data: data)
        Models::Organization.new(response)
      end
    end
  end
end

