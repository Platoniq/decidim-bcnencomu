# frozen_string_literal: true

module ApplicationHelper
  def fearlesscities_site?
    return false unless Rails.application.secrets.fearlesscities

    Rails.application.secrets.fearlesscities.include? current_organization&.host&.to_str
  end
end
