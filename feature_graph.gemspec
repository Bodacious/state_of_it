# frozen_string_literal: true

require_relative 'lib/feature_graph/version'

Gem::Specification.new do |spec|
  spec.name = 'feature_graph'
  spec.version = FeatureGraph::VERSION
  spec.authors = ['Gavin Morrice']
  spec.email = ['gavin@gavinmorrice.com']

  spec.summary = 'Add features to test users without the mess'
  spec.description = 'Creates a dependency graph so that features ' \
                     'for test users are added in the correct order.'
  spec.homepage = 'https://github.com/bodacious/feature_graph'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'activesupport'
  spec.add_dependency 'tsort'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
