# frozen_string_literal: true

require_relative "lib/loco_sync/version"

Gem::Specification.new do |spec|
  spec.name = "loco-sync"
  spec.version = LocoSync::VERSION
  spec.authors = ["Adam Zar"]
  spec.email = ["adam.zar@olioex.com"]
  spec.summary = "Sync translations with localise.biz for ruby on rails"
  spec.description = "This gem enables an exchange of translation files between your Rails app and localise.biz."
  spec.homepage = "https://github.com/OLIOEX/loco-sync"
  spec.license = "Apache 2.0"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir[
    "README.md", "LICENSE",
    "CHANGELOG.md", "lib/**/*.rb",
    "lib/**/*.rake", "loco-sync.gemspec",
    "Gemfile", "Rakefile"
  ]
  spec.extra_rdoc_files = ["README.md"]

  spec.add_development_dependency "rubocop", "~> 0.60"
end