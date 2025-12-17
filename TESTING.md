# Testing the Volley Ruby SDK

This document describes how to run tests for the Volley Ruby SDK.

## Prerequisites

1. Install dependencies:
```bash
bundle install
```

2. Ensure RSpec is installed (included in dev dependencies):
```bash
bundle exec rspec --version
```

## Running Tests

### Unit Tests

Unit tests use mocked HTTP responses with WebMock and don't require a real API token:

```bash
bundle exec rspec spec/
```

Or run specific test files:

```bash
bundle exec rspec spec/volley_client_spec.rb
bundle exec rspec spec/organizations_resource_spec.rb
```

### Integration Tests

Integration tests make real API calls to the Volley API. These tests are skipped unless `VOLLEY_API_TOKEN` is set.

To run integration tests:

1. Set your API token:
```bash
export VOLLEY_API_TOKEN=your-api-token-here
```

2. Run integration tests:
```bash
bundle exec rspec spec/integration_spec.rb
```

**Note**: Integration tests may create, modify, or delete resources in your account. Use a test account or be prepared to clean up test data.

### Running All Tests

To run all tests (unit and integration):

```bash
bundle exec rspec
```

## Test Coverage

To generate a test coverage report, you can use SimpleCov:

1. Add SimpleCov to your Gemfile:
```ruby
group :test do
  gem 'simplecov', require: false
end
```

2. Add to `spec/spec_helper.rb`:
```ruby
require 'simplecov'
SimpleCov.start
```

3. Run tests:
```bash
bundle exec rspec
```

Coverage reports will be generated in the `coverage/` directory.

## Writing Tests

### Unit Tests

Unit tests should mock HTTP responses using WebMock:

```ruby
require 'webmock/rspec'

RSpec.describe Volley::VolleyClient do
  it 'makes successful request' do
    stub_request(:get, 'https://api.volleyhooks.com/api/org')
      .with(headers: { 'Authorization' => 'Bearer test-token' })
      .to_return(status: 200, body: '{"id": 1, "name": "Test"}')

    client = Volley::VolleyClient.new('test-token')
    response = client.request('GET', '/api/org')
    expect(response['id']).to eq(1)
  end
end
```

### Integration Tests

Integration tests should:
- Check for `VOLLEY_API_TOKEN` environment variable
- Skip if not set
- Clean up any resources created during tests
- Use descriptive test names

Example:

```ruby
RSpec.describe 'Integration Tests', type: :integration do
  let(:api_token) { ENV['VOLLEY_API_TOKEN'] }
  let(:client) { Volley::VolleyClient.new(api_token) if api_token }

  before do
    skip 'VOLLEY_API_TOKEN environment variable is not set' unless api_token
  end

  it 'lists organizations' do
    orgs = client.organizations.list
    expect(orgs).to be_a(Array)
  end
end
```

## Continuous Integration

The SDK includes RSpec configuration that can be used in CI/CD pipelines. The configuration:

- Runs all tests in the `spec/` directory
- Excludes integration tests by default (unless `VOLLEY_API_TOKEN` is set)
- Uses documentation format for better output

## Code Quality

### RuboCop

To check code style:

```bash
bundle exec rubocop
```

To auto-fix issues:

```bash
bundle exec rubocop -a
```

