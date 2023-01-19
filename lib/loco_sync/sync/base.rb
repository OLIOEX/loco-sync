# frozen_string_literal: true

module LocoSync
  module Sync
    class Base
      class << self
        private

        def config
          LocoSync::Config
        end

        def client
          Faraday.new(
            url: url,
            params: params,
            headers: { "Authorization" => "Loco #{api_key}" }
          )
        end
      end
    end
  end
end
