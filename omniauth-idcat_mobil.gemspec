# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth/idcat_mobil/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-idcat_mobil"
  spec.version = Omniauth::IdCatMobil::VERSION
  spec.authors = ["Oliver Valls"]
  spec.email = ["oliver.vh@coditramuntana.com"]

  spec.summary = "User registration and login through IdCat mòbil."
  spec.description = "Authentication method that uses OAuth 2.0 protocol."
  spec.homepage = "https://github.com/gencat/omniauth-idcat_mobil"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth", "~> 2.0.4"
  spec.add_dependency "omniauth-oauth2", ">= 1.7.2", "< 2.0"
  spec.add_development_dependency "bundler", "~> 2.2", ">= 2.2.10"
  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.3"
  spec.metadata["rubygems_mfa_required"] = "true"
end
