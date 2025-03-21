# frozen_string_literal: true

Decidim::Civicrm.configure do |config|
  # Configure api credentials
  config.api = {
    key: Rails.application.secrets.dig(:civicrm, :api, :key),
    secret: Rails.application.secrets.dig(:civicrm, :api, :secret),
    url: Rails.application.secrets.dig(:civicrm, :api, :url),
    version: Rails.application.secrets.dig(:civicrm, :api, :version)
  }

  # Configure omniauth secrets
  config.omniauth = {
    client_id: Rails.application.secrets.dig(:omniauth, :civicrm, :client_id),
    client_secret: Rails.application.secrets.dig(:omniauth, :civicrm, :client_secret),
    site: Rails.application.secrets.dig(:omniauth, :civicrm, :site)
  }

  # whether to send notifications to user when they auto-verified or not:
  config.send_verification_notifications = false

  config.send_meeting_registration_notifications = false
end
