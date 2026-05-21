# frozen_string_literal: true

require "yaml"
require_relative "base"

module LocoSync
  module Sync
    # Imports a locale file from Loco into the local Rails project.
    #
    # `GET /api/export/locale/{locale}.{ext}` is CDN-served; CDN endpoints
    # only accept the API key via the `key` query parameter and respond
    # with 401 "invalid project key" when an Authorization header is
    # used (see https://localise.biz/help/developers/api-keys).
    #
    # The importer is intentionally fault-tolerant: any failure (HTTP
    # error, invalid YAML, wrong root key) is logged and the destination
    # file is either left alone (if it already contains a valid
    # translation document) or replaced with a `{locale}: {}` placeholder
    # so Rails still boots. Deploys never abort on Loco issues; the next
    # successful import heals any placeholder.
    class Import < Base
      class << self
        attr_reader :locale

        def import!(locale:)
          @locale = locale
          destination = "#{config.locales_path}/#{locale}.yml"

          begin
            response = client(auth_via: :query).get
          rescue Faraday::Error => error
            handle_import_failure(destination, error_message("import", locale, error))
            return
          end

          validation_error = validation_error_for(response.body)
          if validation_error
            handle_import_failure(destination, validation_error)
            return
          end

          atomic_write(destination, response.body)
        rescue StandardError => error
          warn "[loco_sync:import] Unexpected error for locale=#{locale}: #{error.class}: #{error.message}. " \
               "Leaving #{destination} untouched."
        end

        private

        def api_key
          config.import_api_key
        end

        def url
          "https://localise.biz/api/export/locale/#{locale}.yml"
        end

        def params
          config.import_opts
        end

        def handle_import_failure(destination, reason)
          warn "[loco_sync:import] #{reason}"

          if existing_file_valid?(destination)
            warn "[loco_sync:import] Keeping existing #{destination}; translations may be stale."
          else
            warn "[loco_sync:import] Writing placeholder to #{destination}; boot will succeed but locale will be empty."
            write_placeholder(destination, reason)
          end
        end

        def validation_error_for(body)
          parsed =
            begin
              YAML.safe_load(body, permitted_classes: [], aliases: true)
            rescue Psych::SyntaxError => error
              return "Loco import for locale=#{locale} url=#{url} returned invalid YAML " \
                     "(#{error.message}). Body: #{safe_excerpt(body)}"
            end

          return nil if parsed.is_a?(Hash) && parsed.size == 1 && root_matches_locale?(parsed.keys.first)

          root = parsed.is_a?(Hash) ? parsed.keys.inspect : parsed.class
          "Loco import for locale=#{locale} url=#{url} returned unexpected structure " \
            "(root was #{root}). Body: #{safe_excerpt(body)}"
        end

        # Accepts the requested locale, its language tag with a region
        # subtag (e.g. `ko` request → `ko-KR` response), or the underscore
        # variant. Loco exports the project's canonical locale code, which
        # is often more specific than the locale you request by.
        def root_matches_locale?(root_key)
          return false unless root_key.is_a?(String)

          root = root_key.downcase
          prefix = locale.to_s.downcase
          root == prefix || root.start_with?("#{prefix}-") || root.start_with?("#{prefix}_")
        end

        def existing_file_valid?(path)
          return false unless File.exist?(path)

          validation_error_for(File.read(path)).nil?
        end

        def atomic_write(destination, body)
          tempfile = "#{destination}.partial"
          File.binwrite(tempfile, body)
          File.rename(tempfile, destination)
        ensure
          File.delete(tempfile) if File.exist?(tempfile)
        end

        def write_placeholder(destination, reason)
          timestamp = Time.now.utc.iso8601
          safe_reason = safe_excerpt(reason).tr("\n", " ")
          placeholder = <<~YAML
            # Placeholder written by loco_sync:import on #{timestamp}.
            # The import failed and no usable locale file existed on disk.
            # Reason: #{safe_reason}
            #{locale}: {}
          YAML
          atomic_write(destination, placeholder)
        end
      end
    end
  end
end
