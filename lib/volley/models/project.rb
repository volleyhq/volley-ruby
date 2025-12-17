# frozen_string_literal: true

module Volley
  module Models
    # Project model.
    class Project
      attr_accessor :id, :name, :organization_id, :user_id, :is_default, :created_at, :updated_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @name = data['name'] || data[:name] || ''
        @organization_id = data['organization_id'] || data[:organization_id] || 0
        @user_id = data['user_id'] || data[:user_id]
        @is_default = data['is_default'] || data[:is_default] || false
        @created_at = data['created_at'] || data[:created_at] || ''
        @updated_at = data['updated_at'] || data[:updated_at] || ''
      end
    end
  end
end

