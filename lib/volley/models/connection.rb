# frozen_string_literal: true

module Volley
  module Models
    # Connection model.
    class Connection
      attr_accessor :id, :source_id, :destination_id, :status, :eps, :max_retries, :created_at, :updated_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @source_id = data['source_id'] || data[:source_id] || 0
        @destination_id = data['destination_id'] || data[:destination_id] || 0
        @status = data['status'] || data[:status] || ''
        @eps = data['eps'] || data[:eps] || 0
        @max_retries = data['max_retries'] || data[:max_retries] || 0
        @created_at = data['created_at'] || data[:created_at] || ''
        @updated_at = data['updated_at'] || data[:updated_at] || ''
      end
    end
  end
end

