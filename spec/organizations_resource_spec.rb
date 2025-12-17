# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Volley::Resources::OrganizationsResource do
  let(:client) { Volley::VolleyClient.new('test-token') }
  let(:resource) { client.organizations }

  describe '#list' do
    it 'lists organizations' do
      stub_request(:get, 'https://api.volleyhooks.com/api/org/list')
        .to_return(status: 200, body: '{"organizations": [{"id": 1, "name": "Org 1", "slug": "org-1", "role": "admin"}]}')

      orgs = resource.list
      expect(orgs.length).to eq(1)
      expect(orgs[0]).to be_a(Volley::Models::Organization)
      expect(orgs[0].name).to eq('Org 1')
    end
  end

  describe '#get' do
    it 'gets organization' do
      stub_request(:get, 'https://api.volleyhooks.com/api/org')
        .to_return(status: 200, body: '{"id": 1, "name": "Test Org", "slug": "test-org", "role": "admin"}')

      org = resource.get
      expect(org).to be_a(Volley::Models::Organization)
      expect(org.name).to eq('Test Org')
    end
  end

  describe '#create' do
    it 'creates organization' do
      stub_request(:post, 'https://api.volleyhooks.com/api/org')
        .with(body: '{"name":"New Org"}')
        .to_return(status: 201, body: '{"id": 1, "name": "New Org", "slug": "new-org", "role": "admin"}')

      org = resource.create(name: 'New Org')
      expect(org).to be_a(Volley::Models::Organization)
      expect(org.name).to eq('New Org')
    end
  end
end

