# frozen_string_literal: true

module Volley
  module Models
    # Delivery Attempt model.
    class DeliveryAttempt
      attr_accessor :id, :event_id, :connection_id, :status, :status_code, :error_reason, :duration_ms, :created_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @event_id = data['event_id'] || data[:event_id] || ''
        @connection_id = data['connection_id'] || data[:connection_id] || 0
        @status = data['status'] || data[:status] || ''
        @status_code = data['status_code'] || data[:status_code] || 0
        @error_reason = data['error_reason'] || data[:error_reason]
        @duration_ms = data['duration_ms'] || data[:duration_ms] || 0
        @created_at = data['created_at'] || data[:created_at] || ''
      end
    end
  end
end

