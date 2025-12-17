# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'json'
require_relative 'volley_exception'
require_relative 'resources/organizations_resource'
require_relative 'resources/projects_resource'
require_relative 'resources/sources_resource'
require_relative 'resources/destinations_resource'
require_relative 'resources/connections_resource'
require_relative 'resources/events_resource'
require_relative 'resources/delivery_attempts_resource'
require_relative 'resources/webhooks_resource'

module Volley
  # Main client for interacting with the Volley API.
  class VolleyClient
    DEFAULT_BASE_URL = 'https://api.volleyhooks.com'
    DEFAULT_TIMEOUT = 30

    attr_reader :api_token, :base_url, :organization_id
    attr_reader :organizations, :projects, :sources, :destinations, :connections, :events, :delivery_attempts, :webhooks

    # Initializes a new instance of the VolleyClient class.
    #
    # @param api_token [String] Your Volley API token
    # @param base_url [String, nil] Custom base URL (defaults to https://api.volleyhooks.com)
    # @param organization_id [Integer, nil] Organization ID for all requests
    # @param http_client [Faraday::Connection, nil] Custom Faraday HTTP client (optional)
    def initialize(api_token, base_url: nil, organization_id: nil, http_client: nil)
      raise ArgumentError, 'API token is required' if api_token.nil? || api_token.empty?

      @api_token = api_token
      @base_url = base_url || DEFAULT_BASE_URL
      @organization_id = organization_id

      @http_client = http_client || build_http_client

      # Initialize resource clients
      @organizations = Resources::OrganizationsResource.new(self)
      @projects = Resources::ProjectsResource.new(self)
      @sources = Resources::SourcesResource.new(self)
      @destinations = Resources::DestinationsResource.new(self)
      @connections = Resources::ConnectionsResource.new(self)
      @events = Resources::EventsResource.new(self)
      @delivery_attempts = Resources::DeliveryAttemptsResource.new(self)
      @webhooks = Resources::WebhooksResource.new(self)
    end

    # Sets the organization ID for subsequent requests.
    #
    # @param organization_id [Integer] The organization ID to use
    def set_organization_id(organization_id)
      @organization_id = organization_id
    end

    # Clears the organization ID (uses default organization).
    def clear_organization_id
      @organization_id = nil
    end

    # Gets the current organization ID.
    #
    # @return [Integer, nil] The organization ID, or nil if not set
    def get_organization_id
      @organization_id
    end

    # Performs an HTTP request with authentication.
    #
    # @param method [String] HTTP method (GET, POST, PUT, DELETE)
    # @param path [String] API path (e.g., /api/org)
    # @param data [Hash, nil] Request body data (for POST/PUT)
    # @param query_params [Hash, nil] Query parameters
    # @return [Hash] Response data
    # @raise [VolleyException] If the request fails
    def request(method, path, data: nil, query_params: nil)
      url = "#{@base_url}#{path}"

      headers = {
        'Authorization' => "Bearer #{@api_token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
      headers['X-Organization-ID'] = @organization_id.to_s if @organization_id

      response = @http_client.public_send(method.downcase.to_sym) do |req|
        req.url url
        req.headers = headers
        req.body = data.to_json if data && %w[post put].include?(method.downcase)
        req.params = query_params if query_params
      end

      handle_response(response)
    rescue Faraday::Error => e
      raise VolleyException.new("Request failed: #{e.message}", 0)
    end

    private

    def build_http_client
      Faraday.new do |f|
        f.request :retry, {
          max: 3,
          interval: 1,
          retry_statuses: [429, 500, 502, 503, 504]
        }
        f.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      unless response.success?
        error_message = 'Request failed'
        begin
          error_data = JSON.parse(response.body)
          error_message = error_data['error'] || error_data['message'] || error_message
        rescue JSON::ParserError
          error_message = response.body || error_message
        end
        raise VolleyException.new(error_message, response.status)
      end

      return {} if response.body.nil? || response.body.empty?

      JSON.parse(response.body)
    rescue JSON::ParserError
      {}
    end
  end
end

