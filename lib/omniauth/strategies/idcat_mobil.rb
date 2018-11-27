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

      option :user_info_path, "/serveis-rest/getUserInfo"

      # uid: this is a unique string identifier that is globally unique to the provider you're writing
      uid do
        raw_info["identifier"]
      end

      # info: this method should return a hash of information about the user with keys taken from the [Auth Hash Schema](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema)
      info do
        {
          email: raw_info["email"],
          name: raw_info["name"],
          prefix: raw_info["prefix"],
          phone: raw_info["phone"],
          surname1: raw_info["surname1"],
          surname2: raw_info["surname2"],
          surnames: raw_info["surnames"],
          country_code: raw_info["countryCode"],
          email: raw_info["email"],
        }
      end

      # extra: this method returns information not directly related with the user
      def extra
        {
          identifier_type: raw_info["identifierType"],
          method: raw_info["method"],
          assurance_level: raw_info["assuranceLevel"],
          status: raw_info["status"]
        }
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = URI.join(options.site, "/o/oauth2/auth").to_s
        options.client_options[:authorize_params] = {
          scope: :autenticacio_usuari,
          response_type: :code,
          approval_prompt: :auto,
          access_type: :online,
        }
        options.client_options[:token_url] = URI.join(options.site, "/o/oauth2/token").to_s
        options.client_options[:auth_token_params] = {
          mode: :query,
          param_name: 'AccessToken'
        }
        super
      end

      def raw_info
        @raw_info ||= access_token.get(options.user_info_path).parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end