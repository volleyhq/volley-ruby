# frozen_string_literal: true

require_relative 'lib/volley/version'

Gem::Specification.new do |spec|
  spec.name          = 'volley-ruby'
  spec.version       = Volley::VERSION
  spec.authors       = ['Volley']
  spec.email         = ['support@volleyhooks.com']

  spec.summary       = 'Official Ruby SDK for the Volley API'
  spec.description   = 'Official Ruby SDK for the Volley webhook infrastructure API'
  spec.homepage      = 'https://github.com/volleyhq/volley-ruby'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/volleyhq/volley-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/volleyhq/volley-ruby/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github .rspec .rubocop Gemfile Rakefile])
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.50'
  spec.add_development_dependency 'webmock', '~> 3.18'
end

