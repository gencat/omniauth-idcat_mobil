# frozen_string_literal: true

require "spec_helper"

describe OmniAuth::Strategies::IdCatMobil do
  subject do
    strategy
  end

  let(:access_token) { instance_double("AccessToken", options: {}) }
  let(:parsed_response) { instance_double("ParsedResponse") }
  let(:response) { instance_double("Response", parsed: parsed_response) }
  let(:strategy) do
    described_class.new(
      app,
      "CLIENT_ID",
      "CLIENT_SECRET",
      "https://identitats-pre.aoc.cat")
  end
  let(:app) do
    lambda do |_env|
      [200, {}, ["Hello."]]
    end
  end
  let(:uid) { {"identifier" => "123456789"} }
  let(:info) do
    {
      "email"           => "email@example.net",
      "name"            => "Oriol",
      "prefix"          => "972",
      "phone"           => "505152",
      "surname1"        => "Junqueras",
      "surname2"        => "Vies",
      "surnames"        => "Junqueras Vies",
      "countryCode"    => "CAT",
    }    
  end
  let(:extra) do
    {
      "identifier_type" => "1",
      "method"          => "idcatmobil",
      "assurance_level" => "low",
      "status"          => "ok"
    }
  end
  let(:raw_info_hash) do
    uid.merge(info).merge(extra)
  end

  before do
    allow(strategy).to receive(:access_token).and_return(access_token)
    OmniAuth.config.full_host= "https://test.participa.gencat.cat"
    allow(strategy).to receive(:script_name).and_return("/users")
  end

  describe "client options" do
    it "should have correct name" do
      expect(subject.options.name).to eq(:idcat_mobil)
    end

    it "should have correct site" do
      expect(subject.client.site).to eq("https://identitats-pre.aoc.cat")
    end

    it "should have correct authorize url" do
      expect(subject.client.options[:authorize_url]).to eq("https://identitats-pre.aoc.cat/o/oauth2/auth")
    end

    it "should have correct authorize params" do
      # https://identitats-pre.aoc.cat/o/oauth2/auth?client_id=xxxxxx&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fauth%2Fidcat_mobil%2Fcallback&response_type=code&state=2ec1a9a9db94fbce7f19ee30d682ab75f97f4fd67848773c&approval_prompt=auto&scope=autenticacio_usuari&response_type=code
      expect(subject.client.id).to eq('CLIENT_ID')
      expect(subject.client.secret).to eq('CLIENT_SECRET')
      expect(subject.client.options[:authorize_params][:scope]).to eq(:autenticacio_usuari)
      expect(subject.client.options[:authorize_params][:response_type]).to eq(:code)
      expect(subject.client.options[:authorize_params][:approval_prompt]).to eq(:auto)
      expect(subject.client.options[:authorize_params][:access_type]).to eq(:online)
    end

    it "has the correct token url" do
      expect(subject.client.options[:token_url]).to eq("https://identitats-pre.aoc.cat/o/oauth2/token")
    end

    it "should have correct AccessToken params" do
      expect(subject.options.auth_token_params[:mode]).to eq(:query)
      expect(subject.options.auth_token_params[:param_name]).to eq('AccessToken')
    end

    it "should have the correct user_info_path" do
      expect(subject.options.user_info_path).to eq("/serveis-rest/getUserInfo")
    end
  end

  describe "#callback_url" do
    it "is a combination of host, script name, and callback path" do
      expect(subject.callback_url).to eq("https://test.participa.gencat.cat/users/auth/idcat_mobil/callback")
    end
  end

  describe "uid" do
    before do
      allow(strategy).to receive(:raw_info).and_return(raw_info_hash)
    end

    it "returns the identifier" do
      expect(subject.uid).to eq(uid['identifier'])
    end
  end

  describe "info" do
    before do
      allow(strategy).to receive(:raw_info).and_return(raw_info_hash)
    end

    it "returns the set of info fields" do
      h= keys_to_sym(info)
      h[:country_code]= h.delete(:countryCode)
      expect(subject.info).to eq(h)
    end
  end

  describe "extra" do
    before do
      allow(strategy).to receive(:raw_info).and_return(raw_info_hash)
    end

    it "returns the set of info fields" do
      h= keys_to_sym(extra)
      h[:identifier_type]= h.delete(:identifierType)
      h[:assurance_level]= h.delete(:assuranceLevel)
      expect(subject.extra).to eq(h)
    end
  end

  def keys_to_sym(hash)
    new_hash = {}
    hash.each_pair do |key, value|
      new_hash[key.to_sym]= value
    end
    new_hash
  end
end
