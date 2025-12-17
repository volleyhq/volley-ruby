# frozen_string_literal: true

require 'spec_helper'

# Integration tests that make real API calls.
# These tests are skipped unless VOLLEY_API_TOKEN is set.
RSpec.describe 'Integration Tests', type: :integration do
  let(:api_token) { ENV['VOLLEY_API_TOKEN'] }
  let(:client) { Volley::VolleyClient.new(api_token) if api_token }

  before do
    skip 'VOLLEY_API_TOKEN environment variable is not set' unless api_token
    # Allow real HTTP connections for integration tests
    WebMock.allow_net_connect!(net_http_connect_on_start: true)
  end

  after do
    # Re-enable WebMock blocking after integration tests
    WebMock.disable_net_connect!
  end

  describe '#list_organizations' do
    it 'lists organizations' do
      orgs = client.organizations.list
      expect(orgs).to be_a(Array)
      # May be empty for new accounts, which is OK
    end
  end

  describe '#get_organization' do
    it 'gets organization' do
      orgs = client.organizations.list
      skip 'No organizations available' if orgs.empty?

      org = client.organizations.get(organization_id: orgs[0].id)
      expect(org.id).to eq(orgs[0].id)
    end
  end

  describe '#list_projects' do
    it 'lists projects' do
      orgs = client.organizations.list
      skip 'No organizations available' if orgs.empty?

      client.set_organization_id(orgs[0].id)
      projects = client.projects.list
      expect(projects).to be_a(Array)
      # May be empty, which is OK
    end
  end

  describe '#list_sources' do
    it 'lists sources' do
      orgs = client.organizations.list
      skip 'No organizations available' if orgs.empty?

      client.set_organization_id(orgs[0].id)
      projects = client.projects.list
      skip 'No projects available' if projects.empty?

      sources = client.sources.list(project_id: projects[0].id)
      expect(sources).to be_a(Array)
      # May be empty, which is OK
    end
  end
end

