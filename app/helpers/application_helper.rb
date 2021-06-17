# frozen_string_literal: true

module ApplicationHelper
  def fearlesscities_site?
    return false unless fearlesscities = Rails.application.secrets.fearlesscities

    fearlesscities.include? current_organization&.host&.to_str
  end
end
