require 'spec_helper'

describe "TaxableIncomeController", type: :request do
  describe "GET" do
    it "accepts positive numbers" do
      get "/taxable_income", params: {amount: "11000"}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to eq(100)
      expect(response.status).to eq(200)
    end

    it "rejects zero" do
      get "/taxable_income", params: {amount: "0"}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to     be_nil
      expect(data[:message]).to      eq("amount must be a number above 0")
      expect(response.status).to     eq(422)
    end

    it "rejects negative numbers" do
      get "/taxable_income", params: {amount: "-1"}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to     be_nil
      expect(data[:message]).to      eq("amount must be a number above 0")
      expect(response.status).to     eq(422)
    end

    it "rejects words" do
      get "/taxable_income", params: {amount: "ELEVENTY BILLION DOLLARS"}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to     be_nil
      expect(data[:message]).to      eq("amount must be a number above 0")
      expect(response.status).to     eq(422)
    end
  end
end
