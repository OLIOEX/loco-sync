# frozen_string_literal: true

require_relative "base"

module LocoSync
  module Sync
    class Export < Base
      class << self
        attr_reader :locale

        def export!(locale:)
          translations_file = File.read("#{config.locales_path}/#{locale}.yml")
          @locale = locale

          response = client.post do |req|
              req.body = translations_file
          end  
          response.body
        rescue Faraday::Error => e
          raise "Loco Sync failed to export locale #{locale}: #{e.response[:body]}"
        end

        private

        def api_key
          export_api_key
        end

        def url
          "https://localise.biz/api/import/yml"
        end

        def params
          export_opts.merge({
                              locale: locale,
                              path: "/config/locales/#{locale}.yml"
                            })
        end
      end
    end
  end
end
