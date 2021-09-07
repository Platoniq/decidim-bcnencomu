# frozen_string_literal: true

Decidim::Verifications.register_workflow(:civicrm) do |workflow|
  workflow.form = "Decidim::Civicrm::Verifications::CivicrmVerification"
end

ActiveSupport::Notifications.subscribe(/^decidim\.user\.omniauth_registration/) do |_name, data|
  Decidim::Civicrm::VerificationJob.new.perform(data.to_json)
end
