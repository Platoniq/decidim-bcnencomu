# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class CivicrmSyncGroupsWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["civicrm:sync:groups"].invoke
  end
end
