# frozen_string_literal: true

module LocoSync
  module Sync
    class Base
      class << self
        # Build the Faraday client used for a Loco API request.
        #
        # auth_via: :header (default) sends `Authorization: Loco <key>`. This
        #           is the preferred mode for endpoints that accept it.
        # auth_via: :query sends the key as the `key` query parameter. CDN
        #           endpoints (e.g. GET /api/export/locale/{locale}.{ext})
        #           only accept this form and will respond with 401
        #           "invalid project key" if an Authorization header is sent.
        #
        # The `raise_error` middleware is added so any non-2xx response
        # raises a typed `Faraday::Error` instead of returning silently and
        # leaving callers to inspect status codes by hand.
        def client(auth_via: :header)
          query_params = auth_via == :query ? params.merge(key: api_key) : params
          headers = auth_via == :header ? { "Authorization" => "Loco #{api_key}" } : {}

          Faraday.new(
            url: url,
            params: query_params,
            headers: headers
          ) do |connection|
            connection.response :raise_error
            connection.adapter Faraday.default_adapter
          end
        end

        # Build a useful error message from a Faraday::Error, scrubbing
        # any non-UTF-8 bytes in the response body so the message can be
        # safely logged and interpolated into Ruby strings.
        def error_message(operation, locale, error)
          status =
            if error.respond_to?(:response_status) && error.response_status
              error.response_status
            else
              error.response&.dig(:status) || "no response"
            end
          body =
            if error.respond_to?(:response_body) && error.response_body
              error.response_body
            else
              error.response&.dig(:body)
            end
          "Loco Sync #{operation} failed locale=#{locale} url=#{url} " \
            "status=#{status}: #{safe_excerpt(body)} (#{error.class})"
        end

        def safe_excerpt(value, limit = 500)
          value.to_s.byteslice(0, limit).to_s.dup.force_encoding(Encoding::UTF_8).scrub("?")
        end

        private

        def config
          LocoSync::Config
        end
      end
    end
  end
end
