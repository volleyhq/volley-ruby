# frozen_string_literal: true

module Volley
  module Models
    # Source model.
    class Source
      attr_accessor :id, :slug, :ingestion_id, :type, :eps, :status, :connection_count, :auth_type,
                    :verify_signature, :webhook_secret_set, :auth_username, :auth_key_name, :created_at, :updated_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @slug = data['slug'] || data[:slug] || ''
        @ingestion_id = data['ingestion_id'] || data[:ingestion_id] || ''
        @type = data['type'] || data[:type] || ''
        @eps = data['eps'] || data[:eps] || 0
        @status = data['status'] || data[:status] || ''
        @connection_count = data['connection_count'] || data[:connection_count] || 0
        @auth_type = data['auth_type'] || data[:auth_type] || ''
        @verify_signature = data['verify_signature'] || data[:verify_signature] || false
        @webhook_secret_set = data['webhook_secret_set'] || data[:webhook_secret_set] || false
        @auth_username = data['auth_username'] || data[:auth_username]
        @auth_key_name = data['auth_key_name'] || data[:auth_key_name]
        @created_at = data['created_at'] || data[:created_at] || ''
        @updated_at = data['updated_at'] || data[:updated_at] || ''
      end
    end
  end
end

