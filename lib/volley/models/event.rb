# frozen_string_literal: true

module Volley
  module Models
    # Event model.
    class Event
      attr_accessor :id, :event_id, :source_id, :project_id, :raw_body, :headers, :status, :delivery_attempts, :created_at

      def initialize(data = {})
        @id = data['id'] || data[:id]
        @event_id = data['event_id'] || data[:event_id] || ''
        @source_id = data['source_id'] || data[:source_id] || 0
        @project_id = data['project_id'] || data[:project_id] || 0
        @raw_body = data['raw_body'] || data[:raw_body] || ''
        @headers = data['headers'] || data[:headers] || {}
        @status = data['status'] || data[:status] || ''
        @delivery_attempts = data['delivery_attempts'] || data[:delivery_attempts]
        @created_at = data['created_at'] || data[:created_at] || ''
      end
    end
  end
end

