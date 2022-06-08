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
      # constructor arguments after `app`, the first argument, that should be a RackApp
      args [:client_id, :client_secret, :site]

      option :name, :idcat_mobil
      option :auth_token_params, {
        mode: :query, # put the param in the query of the requested url
        param_name: "AccessToken"
      }

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
          country_code: raw_info["countryCode"]
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
          access_type: :online
        }
        options.client_options[:token_url] = URI.join(options.site, "/o/oauth2/token").to_s
        options.client_options[:auth_token_params] = {
          client_id: super.id,
          client_secret: super.secret,
          redirect_uri: callback_url
        }
        super
      end

      # The +request_phase+ is the first phase after the setup/initialization phase.
      #
      # It is implemented in the OAuth2 superclass, and does the follwing:
      # redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(options.authorize_params))
      #
      # We're overriding solely to log.
      def request_phase
        idcat_log("In `request_phase`, with params: redirect_uri=>#{callback_url}, options=>#{options.authorize_params}")
        idcat_log("`request_phase`, redirecting the user to AOC...")
        super
      end

      # The +callback_phase+ is the second phase, after the user returns from the authentication provider site.
      #
      # The result of the authentication may have ended in error, or success.
      # In case of success we still have to ask the authentication provider for the access_token.
      # That's what we do in this callback.
      def callback_phase
        idcat_log("In `callback_phase` with request params: #{request.params}")
        idcat_log("Both should be equal otherwise a 'CSRF detected' error is raised: params state[#{request.params["state"]}] =? [#{session["omniauth.state"]}] session state.")
        super
      end

      def raw_info
        if @raw_info
          idcat_log("Access token response was: #{access_token.try(:response)}")
        else
          idcat_log("Performing getUserInfo...")
          response= access_token.get(options.user_info_path)
          result= [:status, :headers, :body].collect { |m| response.send(m) }
          idcat_log("getUserInfo response status/headers/body: #{result}")
          @raw_info= response.parsed
          # Logout to avoid problems with IdCat mòbil's cookie session when trying to login again.
          logout_url= URI.join(options.site, "/o/oauth2/logout?token=#{access_token.token}").to_s
          access_token.get(logout_url)
        end
        @raw_info
      end

      # The url where the provider should redirect the users to after authenticating.
      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        File.join([full_host, script_name, callback_path].compact)
      end

      # --------------------------------------------------
      private

      # --------------------------------------------------

      def idcat_log(msg)
        idcat_logger.debug(msg)
      end

      def idcat_logger
        @idcat_logger||= defined?(Rails.logger) ? Rails.logger : Logger.new($stdout, progname: "idcat_mobil")
      end
    end
  end
end
