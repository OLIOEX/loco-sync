# frozen_string_literal: true

LocoSync::Config.config do |c|
  # These are mandatory options that you must set before running rake tasks:
  # c.import_api_key = ENV['LOCO_IMPORT_API_KEY']
  # c.export_api_key = ENV['LOCO_EXPORT_API_KEY']

  # Provide a custom path to the directory with your translation files:
  # c.locales_path = "#{Rails.root}/config/locales"

  # Import options have the following defaults:
  # c.import_opts = {
  #   index: :id,
  #   format: :rails,
  #   fallback: :en,
  #   order: :id,
  #   filter: ""
  # }

  # Export options have the following defaults:
  # c.export_opts = {
  #   index: :id,
  #   format: :rails,
  #   "ignore-new": false,
  #   "ignore-existing": true,
  #   "tag-absent": "unused",
  #   "flag-new": "Provisional",
  #   "untag-all": "unused"
  # }

  # Locales to import or export
  # c.locales = ["en"]

  # Loco api base url
  # c.base_url = "https://localise.biz/api/"
end
