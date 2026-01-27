# frozen_string_literal: true

require "spec_helper"

describe OmniAuth::AuthHash do
  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: "idcat_mobil",
      uid: "123456789",
      info: {
        email: "email@example.net",
        name: "Oriol",
        surname1: "Junquerol",
        surname2: "Balaguer"
      },
      credentials: {
        token: "fake_token",
        expires: false
      },
      extra: {
        identifier_type: "1",
        method: "idcatmobil",
        status: "ok"
      }
    )
  end

  describe "indifferent access" do
    it "is accessible with string keys at root level" do
      expect(auth_hash["provider"]).to eq("idcat_mobil")
      expect(auth_hash["uid"]).to eq("123456789")
      expect(auth_hash["info"]).to be_a(Hash)
      expect(auth_hash["credentials"]).to be_a(Hash)
      expect(auth_hash["extra"]).to be_a(Hash)
    end

    it "is accessible with symbol keys at root level" do
      expect(auth_hash[:provider]).to eq("idcat_mobil")
      expect(auth_hash[:uid]).to eq("123456789")
      expect(auth_hash[:info]).to be_a(Hash)
      expect(auth_hash[:credentials]).to be_a(Hash)
      expect(auth_hash[:extra]).to be_a(Hash)
    end

    it "is accessible with string keys in nested hashes" do
      expect(auth_hash["info"]["email"]).to eq("email@example.net")
      expect(auth_hash["info"]["name"]).to eq("Oriol")
      expect(auth_hash["credentials"]["token"]).to eq("fake_token")
      expect(auth_hash["extra"]["method"]).to eq("idcatmobil")
    end

    it "is accessible with symbol keys in nested hashes" do
      expect(auth_hash[:info][:email]).to eq("email@example.net")
      expect(auth_hash[:info][:name]).to eq("Oriol")
      expect(auth_hash[:credentials][:token]).to eq("fake_token")
      expect(auth_hash[:extra][:method]).to eq("idcatmobil")
    end

    it "supports mixed string and symbol access" do
      expect(auth_hash["info"][:email]).to eq("email@example.net")
      expect(auth_hash[:info]["name"]).to eq("Oriol")
      expect(auth_hash["credentials"][:token]).to eq("fake_token")
      expect(auth_hash[:extra]["method"]).to eq("idcatmobil")
    end
  end
end
