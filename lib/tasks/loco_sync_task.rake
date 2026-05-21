# frozen_string_literal: true

require "rake"
require "loco_sync"

if defined?(Rails)
  require "#{Rails.root}/config/initializers/loco_sync"
end

namespace :loco_sync do
  desc "Imports translation files from localise.biz to the current Rails project"
  task import: :environment do
    LocoSync::Config.locales.each do |locale|
      puts "Importing translations for locale: #{locale}"
      LocoSync::Sync::Import.import!(locale: locale)
    end
  end

  desc "Exports translation files from the current Rails project to localise.biz"
  task export: :environment do
    export_locales = LocoSync::Config.export_locales || LocoSync::Config.locales
    export_locales.each do |locale|
      puts "Exporting translations for locale: #{locale}"
      LocoSync::Sync::Export.export!(locale: locale)
    end
  end

  desc "Sync translations with localise.biz"
  task sync: %i(export import)
end
