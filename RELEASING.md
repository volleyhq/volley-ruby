# Releasing the Volley Ruby SDK

This document describes the process for releasing a new version of the Volley Ruby SDK.

## Prerequisites

1. Ensure all tests pass:
```bash
bundle install
bundle exec rspec
```

2. Update version numbers:
   - Update `VERSION` in `lib/volley/version.rb`
   - Update version in `volley-ruby.gemspec` (if needed)

3. Update CHANGELOG.md with the new version and changes

4. Ensure code quality:
```bash
bundle exec rubocop
```

## Release Process

### 1. Build the Gem

```bash
gem build volley-ruby.gemspec
```

This creates a `.gem` file (e.g., `volley-ruby-1.0.0.gem`).

### 2. Test the Gem Locally

```bash
gem install ./volley-ruby-1.0.0.gem
```

Test in a separate directory:

```ruby
require 'volley'
client = Volley::VolleyClient.new('test-token')
# Test basic functionality
```

### 3. Create a Git Tag

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 4. Create a GitHub Release

1. Go to the [GitHub repository](https://github.com/volleyhq/volley-ruby)
2. Click "Releases" → "Draft a new release"
3. Select the tag you just created
4. Add release notes (copy from CHANGELOG.md)
5. Publish the release

### 5. Publish to RubyGems

```bash
gem push volley-ruby-1.0.0.gem
```

**Note**: You need to be logged in to RubyGems. If not already logged in:

```bash
gem signin
```

Enter your RubyGems credentials.

### 6. Verify Release

1. Verify the gem is available on RubyGems:
   ```bash
   gem search volley-ruby
   ```

2. Test installation:
   ```bash
   gem install volley-ruby
   ```

3. Verify the version:
   ```ruby
   require 'volley'
   puts Volley::VERSION
   ```

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backward-compatible manner
- **PATCH** version for backward-compatible bug fixes

## Post-Release Checklist

- [ ] All tests pass
- [ ] Version numbers updated
- [ ] CHANGELOG.md updated
- [ ] Code quality checks pass (RuboCop)
- [ ] Gem built and tested locally
- [ ] Git tag created and pushed
- [ ] GitHub release created
- [ ] Gem published to RubyGems
- [ ] Package available on RubyGems.org
- [ ] Documentation updated (if needed)
- [ ] Announcement posted (if major release)

## Troubleshooting

### Gem Push Fails

If `gem push` fails with authentication errors:
1. Check you're logged in: `gem signin`
2. Verify your credentials are correct
3. Check if the gem name is already taken (should be `volley-ruby`)

### Version Already Exists

If you get an error that the version already exists:
1. Check RubyGems.org to see if the version is already published
2. If it's a mistake, you'll need to yank the version: `gem yank volley-ruby -v 1.0.0`
3. Then republish with the correct version

