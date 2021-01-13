# frozen_string_literal: true
# This migration comes from decidim_meetings (originally 20201216112857)

class AddEmbeddedVideoconferenceToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :embedded_videoconference, :boolean, default: false
  end
end
