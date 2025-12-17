# frozen_string_literal: true

module Volley
  module Models
    # Destination model.
    class Destination
      attr_accessor :id, :name, :url, :eps, :status, :created_at, :updated_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @name = data['name'] || data[:name] || ''
        @url = data['url'] || data[:url] || ''
        @eps = data['eps'] || data[:eps] || 0
        @status = data['status'] || data[:status] || ''
        @created_at = data['created_at'] || data[:created_at] || ''
        @updated_at = data['updated_at'] || data[:updated_at] || ''
      end
    end
  end
end

