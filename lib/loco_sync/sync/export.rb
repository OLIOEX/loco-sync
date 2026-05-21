# frozen_string_literal: true

require_relative "base"

module LocoSync
  module Sync
    # Pushes the locale file from the local Rails project up to Loco.
    #
    # Export is intentionally strict: any non-2xx response raises with the
    # locale, URL, HTTP status, body excerpt, and exception class. Manual
    # exports should fail loudly so a broken push doesn't silently swallow
    # the user's intent.
    class Export < Base
      class << self
        attr_reader :locale

        def export!(locale:)
          @locale = locale
          translations_file = File.read("#{config.locales_path}/#{locale}.yml")

          response = client.post do |req|
            req.body = translations_file
          end

          response.body
        rescue Faraday::Error => error
          raise error_message("export", locale, error)
        end

        private

        def api_key
          config.export_api_key
        end

        def url
          "https://localise.biz/api/import/yml"
        end

        def params
          config.export_opts.merge(
            locale: locale,
            path: "/config/locales/#{locale}.yml"
          )
        end
      end
    end
  end
end
