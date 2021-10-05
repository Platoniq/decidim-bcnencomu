# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "Platoniq/decidim", branch: "temp/0.24" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-alternative_landing", github: "Platoniq/decidim-module-alternative_landing"
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-decidim_awesome", github: "Platoniq/decidim-module-decidim_awesome"
gem "decidim-direct_verifications", "~> 0.22.1"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer"
gem "omniauth-decidim", github: "decidim/omniauth-decidim"

# gem "decidim-civicrm", path: "../../decidim-civicrm"
gem "decidim-civicrm", github: "Platoniq/decidim-module-decidim_civicrm"

gem "bootsnap", "~> 1.4"
gem "health_check"
gem "sentry-rails"
gem "sentry-ruby"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"
gem "rspec"
gem "rubocop-faker"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

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
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron"
end
