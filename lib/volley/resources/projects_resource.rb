# frozen_string_literal: true

require_relative '../models/project'

module Volley
  module Resources
    # Projects API resource.
    class ProjectsResource
      def initialize(client)
        @client = client
      end

      # List all projects in the current organization.
      #
      # @return [Array<Models::Project>]
      def list
        response = @client.request('GET', '/api/projects')
        projects_data = response['projects'] || []
        projects_data.map { |project_data| Models::Project.new(project_data) }
      end

      # Create a new project.
      #
      # @param name [String] Project name
      # @return [Models::Project]
      def create(name:)
        data = { 'name' => name }
        response = @client.request('POST', '/api/projects', data: data)
        Models::Project.new(response)
      end

      # Update a project.
      #
      # @param project_id [Integer] Project ID
      # @param name [String] Updated project name
      # @return [Models::Project]
      def update(project_id:, name:)
        data = { 'name' => name }
        response = @client.request('PUT', "/api/projects/#{project_id}", data: data)
        Models::Project.new(response)
      end

      # Delete a project.
      #
      # @param project_id [Integer] Project ID to delete
      def delete(project_id:)
        @client.request('DELETE', "/api/projects/#{project_id}")
      end
    end
  end
end

