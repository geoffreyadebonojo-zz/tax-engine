require 'spec_helper'

describe "TaxableIncomeController", type: :request do
  describe "GET" do

    describe "without assigned uuid" do

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

    describe "with assigned uuid" do
      it "accepts positive numbers" do
        basic_brackets_csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/basic_functionality_test.csv"
        basic_brackets = CSVParser.execute(basic_brackets_csv_path)
        @basic_user = User.create!(tax_brackets: basic_brackets)

        alternate_brackets_csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/alternate_brackets_test.csv"
        alternate_brackets = CSVParser.execute(alternate_brackets_csv_path)
        @alternate_user = User.create!(tax_brackets: alternate_brackets)

        get "/taxable_income", params: {uuid: @basic_user.uuid, amount: "11000"}
        data = JSON.parse(response.body).symbolize_keys
        expect(data[:tax_owed]).to eq(100)
        expect(response.status).to eq(200)

        get "/taxable_income", params: {uuid: @alternate_user.uuid, amount: "11000"}
        data = JSON.parse(response.body).symbolize_keys
        expect(data[:tax_owed]).to eq(10)
        expect(response.status).to eq(200)
      end
    end

  end
end
