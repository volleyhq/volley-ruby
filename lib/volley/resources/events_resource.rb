# frozen_string_literal: true

require_relative '../models/event'

module Volley
  module Resources
    # Events API resource.
    class EventsResource
      def initialize(client)
        @client = client
      end

      # List events for a project.
      def list(project_id:, limit: nil, offset: nil, source_id: nil, status: nil, start_date: nil, end_date: nil)
        query_params = {}
        query_params['limit'] = limit if limit
        query_params['offset'] = offset if offset
        query_params['source_id'] = source_id if source_id
        query_params['status'] = status if status
        query_params['start_date'] = start_date if start_date
        query_params['end_date'] = end_date if end_date

        response = @client.request('GET', "/api/projects/#{project_id}/events", query_params: query_params)

        events_data = response['requests'] || []
        events = events_data.map { |event_data| Models::Event.new(event_data) }

        {
          events: events,
          total: response['total'] || 0,
          limit: response['limit'] || 0,
          offset: response['offset'] || 0
        }
      end

      # Get an event by ID.
      def get(project_id:, event_id:)
        response = @client.request('GET', "/api/projects/#{project_id}/events/#{event_id}")
        Models::Event.new(response['request'] || {})
      end

      # Replay an event.
      def replay(event_id:, destination_id: nil, connection_id: nil)
        data = { 'event_id' => event_id }
        data['destination_id'] = destination_id if destination_id
        data['connection_id'] = connection_id if connection_id

        response = @client.request('POST', '/api/replay-event', data: data)
        response['message'] || 'Event replayed'
      end
    end
  end
end

