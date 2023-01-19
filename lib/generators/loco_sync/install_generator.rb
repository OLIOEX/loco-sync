# frozen_string_literal: true

require "rails/generators"

module LocoSync
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc "Creates a LocoSync config file."

      def copy_config
        template "loco_sync_config.rb", "#{Rails.root}/config/initializers/loco_sync.rb"
      end
    end
  end
end
