# frozen_string_literal: true

require_relative "base"

module LocoSync
  module Sync
    class Import < Base
      class << self
        attr_reader :locale

        def import!(locale:)
          @locale = locale

          begin
            response = client.get
          rescue Faraday::Error => e
            raise "Loco Sync failed to import locale #{locale}: #{e.response[:body]}"
          end

          File.binwrite("#{config.locales_path}/#{locale}.yml", response.body)
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
      end
    end
  end
end
