# frozen_string_literal: true

LocoSync::Config.config do |c|
  # This option is mandatory. You must set it before running the import rake task:
  c.import_api_key = ENV.fetch("LOCO_READ_KEY")

  # This option is not mandatory for local development however it needs to be set in order to export and sync translations:
  # c.export_api_key = ENV.fetch("LOCO_WRITE_KEY")

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
