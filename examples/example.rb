#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/volley'

# Initialize the client
client = Volley::VolleyClient.new('your-api-token')

# List organizations
orgs = client.organizations.list
orgs.each do |org|
  puts "Organization: #{org.name} (ID: #{org.id})"
end

# Get the first organization
unless orgs.empty?
  org = client.organizations.get(organization_id: orgs[0].id)
  puts "Current organization: #{org.name}"

  # Set organization context
  client.set_organization_id(org.id)

  # List projects
  projects = client.projects.list
  projects.each do |project|
    puts "Project: #{project.name} (ID: #{project.id})"
  end

  # Create a new project
  unless projects.empty?
    project = projects[0]

    # List sources
    sources = client.sources.list(project_id: project.id)
    puts "Found #{sources.length} sources"

    # List events
    events_result = client.events.list(project_id: project.id, limit: 10)
    puts "Found #{events_result[:total]} events"
  end
end

