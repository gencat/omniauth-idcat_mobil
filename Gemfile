# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in omniauth-idcat_mobil.gemspec
gemspec

group :development, :test do
  gem "rubocop"
  gem "rubocop-rspec"
end

group :test do
  gem "rack", ">= 2.1.4"
  gem "rack-test"
  gem "rspec", "~> 3.0"
end
