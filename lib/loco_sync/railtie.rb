# frozen_string_literal: true

module LocoSync
  # Load Rake tasks
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/loco_sync_task.rake"
    end
  end
end
