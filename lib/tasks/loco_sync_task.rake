# frozen_string_literal: true

require "rake"
require "loco_sync"
require "#{Rails.root}/config/initializers/loco_sync"

namespace :loco_sync do
  desc "Imports translation files from localise.biz to the current Rails project"
  task :import do
    LocoSync::Config.locales.each do |locale|
      puts "Importing translations for locale: #{locale}"
      LocoSync::Sync::Import.import!(locale: locale)
    end
  rescue StandardError => e
    abort e.inspect
  end

  desc "Exports translation files from the current Rails project to localise.biz"
  task :export do
    export_locales = LocoSync::Config.export_locales || LocoSync::Config.locales
    export_locales do |locale|
      puts "Exporting translations for locale: #{locale}"
      LocoSync::Sync::Export.export!(locale: locale)
    end
  rescue StandardError => e
    abort e.inspect
  end

  desc "Sync translations with localise.biz"
  task sync: %i(export import)
end
