# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore "#{__dir__}/loco_sync/railtie.rb"
loader.ignore "#{__dir__}/generators/templates/loco_sync_config.rb"
loader.ignore "#{__dir__}/generators/loco_sync/install_generator.rb"
loader.setup

module LocoSync
end

require_relative "loco_sync/railtie" if defined?(Rails)
