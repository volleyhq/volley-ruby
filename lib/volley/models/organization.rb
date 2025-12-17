# frozen_string_literal: true

module Volley
  module Models
    # Organization model.
    class Organization
      attr_accessor :id, :name, :slug, :role, :account_id, :created_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @name = data['name'] || data[:name] || ''
        @slug = data['slug'] || data[:slug] || ''
        @role = data['role'] || data[:role] || ''
        @account_id = data['account_id'] || data[:account_id]
        @created_at = data['created_at'] || data[:created_at]
      end
    end
  end
end

