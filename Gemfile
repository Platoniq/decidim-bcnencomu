# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

#DECIDIM_VERSION = "0.21.0"
DECIDIM_VERSION={ :git => "https://github.com/Platoniq/decidim", :branch => "0.21-stable-fixed-message-consultations"}

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-direct_verifications", github: 'Platoniq/decidim-verifications-direct_verifications'

gem "geocoder", "1.5.2"
gem "bootsnap", "~> 1.4"

gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"
gem "health_check"
gem "sidekiq", "~> 5.2"
gem "sidekiq-cron"
gem "sentry-raven"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem 'dotenv-rails'

  gem "rspec"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem "fog-aws"
end
