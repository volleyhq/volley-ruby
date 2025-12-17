# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Volley::VolleyClient do
  describe '#initialize' do
    it 'creates a client with API token' do
      client = described_class.new('test-token')
      expect(client).to be_a(Volley::VolleyClient)
      expect(client.get_organization_id).to be_nil
    end

    it 'creates a client with organization ID' do
      client = described_class.new('test-token', organization_id: 123)
      expect(client.get_organization_id).to eq(123)
    end

    it 'raises error for empty API token' do
      expect { described_class.new('') }.to raise_error(ArgumentError, 'API token is required')
    end
  end

  describe '#set_organization_id' do
    it 'sets organization ID' do
      client = described_class.new('test-token')
      client.set_organization_id(456)
      expect(client.get_organization_id).to eq(456)
    end
  end

  describe '#clear_organization_id' do
    it 'clears organization ID' do
      client = described_class.new('test-token', organization_id: 123)
      client.clear_organization_id
      expect(client.get_organization_id).to be_nil
    end
  end

  describe '#request' do
    let(:client) { described_class.new('test-token') }

    it 'makes successful GET request' do
      stub_request(:get, 'https://api.volleyhooks.com/api/org')
        .with(headers: { 'Authorization' => 'Bearer test-token' })
        .to_return(status: 200, body: '{"id": 1, "name": "Test Org"}')

      response = client.request('GET', '/api/org')
      expect(response['id']).to eq(1)
      expect(response['name']).to eq('Test Org')
    end

    it 'includes organization ID header when set' do
      client.set_organization_id(789)
      stub_request(:get, 'https://api.volleyhooks.com/api/org')
        .with(headers: { 'X-Organization-ID' => '789' })
        .to_return(status: 200, body: '{}')

      client.request('GET', '/api/org')
    end

    it 'raises VolleyException on error' do
      stub_request(:get, 'https://api.volleyhooks.com/api/org')
        .to_return(status: 400, body: '{"error": "Bad request"}')

      expect { client.request('GET', '/api/org') }.to raise_error(Volley::VolleyException) do |error|
        expect(error.message).to eq('Bad request')
        expect(error.status_code).to eq(400)
      end
    end

    it 'makes POST request with data' do
      stub_request(:post, 'https://api.volleyhooks.com/api/org')
        .with(body: '{"name":"New Org"}')
        .to_return(status: 201, body: '{"id": 1, "name": "New Org"}')

      response = client.request('POST', '/api/org', data: { 'name' => 'New Org' })
      expect(response['name']).to eq('New Org')
    end
  end
end

