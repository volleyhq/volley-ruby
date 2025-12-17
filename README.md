# Volley Ruby SDK

Official Ruby SDK for the Volley API. This SDK provides a convenient way to interact with the Volley webhook infrastructure API.

[Volley](https://volleyhooks.com) is a webhook infrastructure platform that provides reliable webhook delivery, rate limiting, retries, monitoring, and more.

## Resources

- **Documentation**: [https://docs.volleyhooks.com](https://docs.volleyhooks.com)
- **Getting Started Guide**: [https://docs.volleyhooks.com/getting-started](https://docs.volleyhooks.com/getting-started)
- **API Reference**: [https://docs.volleyhooks.com/api](https://docs.volleyhooks.com/api)
- **Authentication Guide**: [https://docs.volleyhooks.com/authentication](https://docs.volleyhooks.com/authentication)
- **Security Guide**: [https://docs.volleyhooks.com/security](https://docs.volleyhooks.com/security)
- **Console**: [https://app.volleyhooks.com](https://app.volleyhooks.com)
- **Website**: [https://volleyhooks.com](https://volleyhooks.com)

## Requirements

- Ruby 2.7.0 or higher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'volley-ruby'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install volley-ruby
```

## Quick Start

```ruby
require 'volley'

# Create a client with your API token
client = Volley::VolleyClient.new('your-api-token')

# Optionally set organization context
client.set_organization_id(123)

# List organizations
orgs = client.organizations.list
orgs.each do |org|
  puts "Organization: #{org.name} (ID: #{org.id})"
end
```

## Authentication

Volley uses API tokens for authentication. These are long-lived tokens designed for programmatic access.

### Getting Your API Token

1. Log in to the [Volley Console](https://app.volleyhooks.com)
2. Navigate to **Settings → Account → API Token**
3. Click **View Token** (you may need to verify your password)
4. Copy the token and store it securely

**Important**: API tokens are non-expiring and provide full access to your account. Keep them secure and rotate them if compromised. See the [Security Guide](https://docs.volleyhooks.com/security) for best practices.

```ruby
client = Volley::VolleyClient.new('your-api-token')
```

For more details on authentication, API tokens, and security, see the [Authentication Guide](https://docs.volleyhooks.com/authentication) and [Security Guide](https://docs.volleyhooks.com/security).

## Organization Context

When you have multiple organizations, you need to specify which organization context to use for API requests. The API verifies that resources (like projects) belong to the specified organization.

You can set the organization context in two ways:

```ruby
# Method 1: Set organization ID for all subsequent requests
client.set_organization_id(123)

# Method 2: Create client with organization ID
client = Volley::VolleyClient.new('your-api-token', organization_id: 123)

# Clear organization context (uses first accessible organization)
client.clear_organization_id
```

**Note**: If you don't set an organization ID, the API uses your first accessible organization by default. For more details, see the [API Reference - Organization Context](https://docs.volleyhooks.com/api#organization-context).

## Examples

### Organizations

```ruby
# List all organizations
orgs = client.organizations.list

# Get current organization
org = client.organizations.get  # nil = use default

# Create organization
new_org = client.organizations.create(name: 'My Organization')
```

### Projects

```ruby
# List projects (requires organization context)
client.set_organization_id(123)
projects = client.projects.list

# Create project
project = client.projects.create(name: 'My Project')

# Update project
updated = client.projects.update(project_id: project.id, name: 'Updated Name')

# Delete project
client.projects.delete(project_id: project.id)
```

### Sources

```ruby
# List sources for a project
sources = client.sources.list(project_id: project_id)

# Create source
source = client.sources.create(
  project_id: project_id,
  slug: 'my-source',
  type: 'webhook',
  eps: 100,
  verify_signature: true
)

# Get source
source = client.sources.get(project_id: project_id, source_id: source_id)

# Update source
updated = client.sources.update(
  project_id: project_id,
  source_id: source_id,
  slug: 'new-slug',
  eps: 200
)

# Delete source
client.sources.delete(project_id: project_id, source_id: source_id)
```

### Destinations

```ruby
# List destinations for a project
destinations = client.destinations.list(project_id: project_id)

# Create destination
destination = client.destinations.create(
  project_id: project_id,
  name: 'My Destination',
  url: 'https://example.com/webhook',
  eps: 50
)

# Get destination
destination = client.destinations.get(project_id: project_id, destination_id: destination_id)

# Update destination
updated = client.destinations.update(
  project_id: project_id,
  destination_id: destination_id,
  name: 'Updated Name',
  url: 'https://new.example.com/webhook'
)

# Delete destination
client.destinations.delete(project_id: project_id, destination_id: destination_id)
```

### Connections

```ruby
# Create connection
connection = client.connections.create(
  project_id: project_id,
  source_id: source_id,
  destination_id: destination_id,
  status: 'active',
  max_retries: 3
)

# Get connection
connection = client.connections.get(connection_id: connection_id)

# Update connection
updated = client.connections.update(
  connection_id: connection_id,
  status: 'paused',
  eps: 100
)

# Delete connection
client.connections.delete(connection_id: connection_id)
```

### Events

```ruby
# List events with filters
result = client.events.list(
  project_id: project_id,
  limit: 10,
  offset: 0,
  source_id: 'src_123',
  status: 'failed'
)

result[:events].each do |event|
  puts "Event ID: #{event.event_id}, Status: #{event.status}"
end

# Get event by ID
event = client.events.get(project_id: project_id, event_id: 'evt_abc123xyz')

# Replay a failed event
message = client.events.replay(event_id: 'evt_abc123xyz')
```

### Delivery Attempts

```ruby
# List delivery attempts with filters
result = client.delivery_attempts.list(
  project_id: project_id,
  event_id: 'evt_abc123xyz',
  status: 'failed',
  limit: 20
)

result[:attempts].each do |attempt|
  puts "Attempt ID: #{attempt.id}, Status: #{attempt.status}"
end
```

### Webhooks

```ruby
# Send a webhook
message = client.webhooks.send(
  source_id: source_id,
  destination_id: destination_id,
  body: { key: 'value', data: 'test' },
  headers: { 'X-Custom-Header' => 'value' }
)
```

## Error Handling

The SDK raises `VolleyException` for API errors. The exception includes the HTTP status code and error message:

```ruby
begin
  org = client.organizations.get(organization_id: 999)
rescue Volley::VolleyException => e
  puts "Error: #{e.message}"
  puts "Status Code: #{e.status_code}"

  # Check specific error types
  if e.not_found?
    puts 'Organization not found'
  elsif e.unauthorized?
    puts 'Authentication failed'
  end
end
```

## Client Options

You can customize the client with additional options:

```ruby
require 'faraday'

# Custom base URL (for testing)
client = Volley::VolleyClient.new(
  'your-api-token',
  base_url: 'https://api.staging.volleyhooks.com'
)

# Custom HTTP client
http_client = Faraday.new do |f|
  f.request :retry, { max: 5, interval: 2 }
end
client = Volley::VolleyClient.new(
  'your-api-token',
  http_client: http_client
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/volleyhq/volley-ruby.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

## Support

- **Documentation**: [https://docs.volleyhooks.com](https://docs.volleyhooks.com)
- **Issues**: [https://github.com/volleyhq/volley-ruby/issues](https://github.com/volleyhq/volley-ruby/issues)
- **Email**: support@volleyhooks.com

