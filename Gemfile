# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/Platoniq/decidim", branch: "release/0.27.4-bcnencomu" }.freeze
# DECIDIM_VERSION = "~> 0.26.1"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-civicrm", git: "https://github.com/Platoniq/decidim-module-civicrm", branch: "chore/upgrade-0.27"
gem "decidim-decidim_awesome"
gem "decidim-direct_verifications"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: :master
gem "omniauth-decidim"

gem "bootsnap", "~> 1.7"
gem "health_check"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"
gem "rspec"

gem "image_processing", ">= 1.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "rubocop-faker"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "fog-aws" # to remove once images migrated
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron"
end
