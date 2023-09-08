# frozen_string_literal: true

module LocoSync
  class Config
    class << self
      attr_accessor :import_api_key, :export_api_key
      attr_writer :import_opts, :export_opts, :locales_path, :export_locales, :locales, :base_url

      def config
        yield self
      end

      def import_opts
        @import_opts || {
          index: :id,
          format: :rails,
          fallback: :en,
          order: :id,
          filter: "!unused",
        }
      end

      def export_opts
        @export_opts || {
          index: :id,
          format: :rails,
          "ignore-new": false,
          "ignore-existing": true,
          "tag-absent": "unused",
          "flag-new": "Provisional",
          "untag-all": "unused",
        }
      end

      def locales_path
        @locales_path || "config/locales"
      end

      def locales
        @locales || %w(en)
      end

      def export_locales
        @export_locales || %w(en)
      end

      def base_url
        @base_url || "https://localise.biz/api/"
      end
    end
  end
end
