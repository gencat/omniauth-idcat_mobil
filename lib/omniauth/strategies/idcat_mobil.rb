# frozen_string_literal: true

require "omniauth-oauth2"
require "open-uri"

module OmniAuth
  module Strategies
    # OAuth references:
    # - https://github.com/omniauth/omniauth/wiki/Strategy-Contribution-Guide
    # - https://github.com/omniauth/omniauth/blob/master/lib/omniauth/strategy.rb
    # - https://github.com/omniauth/omniauth-oauth2/blob/master/lib/omniauth/strategies/oauth2.rb
    # IdCat mòbil references:
    # - https://www.aoc.cat/wp-content/uploads/2016/01/di-valid-1.pdf
    class IdCatMobil < OmniAuth::Strategies::OAuth2
      # constructor arguments after `app` the first argument that should be a RackApp
      args [:client_id, :client_secret, :site]

      option :name, :idcat_mobil
      option :site, nil
      option :client_options, {}

      # uid: this is a unique string identifier that is globally unique to the provider you're writing
      uid do
        raw_info["id"]
      end

      # info: this method should return a hash of information about the user with keys taken from the [Auth Hash Schema](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema)
      info do
        {
          # email: raw_info["email"],
          # nickname: raw_info["nickname"],
          # name: raw_info["name"],
          # image: raw_info["image"]
        }
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = URI.join(options.site, "/o/oauth2/auth").to_s
        options.client_options[:token_url] = URI.join(options.site, "/o/oauth2/token").to_s
        super
      end

      def raw_info
        @raw_info ||= access_token.get("/oauth/me").parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end