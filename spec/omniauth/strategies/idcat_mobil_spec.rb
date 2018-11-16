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
    args= ['appid', 'secret', @options || {}].compact
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
  let(:raw_info_hash) do
    {
      "name" => "IdCat Mòbil",
      "email" => "foo@example.com",
      "nickname" => "Foo Bar",
      "image" => "http://example.org/avatar.jpeg"
    }
  end

  before do
    allow(strategy).to receive(:access_token).and_return(access_token)
  end

  describe "client options" do
    it 'should have correct name' do
      expect(subject.options.name).to eq(:idcat_mobil)
    end

    it "should have correct site" do
      expect(subject.client.site).to eq("https://identitats-pre.aoc.cat")
    end

    it "should have correct authorize url" do
      expect(subject.client.options[:authorize_url]).to eq("https://identitats-pre.aoc.cat/o/oauth2/auth")
    end

    it "has the correct token url" do
      expect(subject.client.options[:token_url]).to eq("https://identitats-pre.aoc.cat/o/oauth2/token")
    end
  end

  describe "#callback_url" do
    it "is a combination of host, script name, and callback path" do
      OmniAuth.config.full_host= "https://test.participa.gencat.cat"
      allow(strategy).to receive(:script_name).and_return("/users")

      expect(subject.callback_url).to eq("https://test.participa.gencat.cat/users/auth/idcat_mobil/callback")
    end
  end

  describe "info" do
    before do
      allow(strategy).to receive(:raw_info).and_return(raw_info_hash)
    end

    it "returns the nickname" do
      expect(subject.info[:nickname]).to eq(raw_info_hash["nickname"])
    end

    it "returns the name" do
      expect(subject.info[:name]).to eq(raw_info_hash["name"])
    end

    it "returns the email" do
      expect(subject.info[:email]).to eq(raw_info_hash["email"])
    end

    it "returns the image" do
      expect(subject.info[:image]).to eq(raw_info_hash["image"])
    end
  end
end
