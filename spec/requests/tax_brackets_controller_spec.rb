require 'rails_helper'

describe "TaxBracketsController", type: :request do
  describe "GET" do
    it "shows existing tax brackets" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])

      get "/tax_brackets", params: {uuid: user.uuid}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_brackets]).to eq([{"lowest_amount"=>10000, "percentage"=>10}, {"lowest_amount"=>20000, "percentage"=>20}])
    end
  end
  describe "CREATE" do
    it "needs a lowest_amount" do
      user = User.create!(tax_brackets: [])
      post "/tax_bracket/new", params: {uuid: user.uuid, lowest_amount: 10000}

      data = JSON.parse(response.body).symbolize_keys
      failure_message = {:message=>"Missing information to create new bracket; please include a lowest_amount and a percentage", :existing_tax_brackets=>[]}
      expect(data).to eq(failure_message)
    end

    it "needs a percentage" do
      user = User.create!(tax_brackets: [])
      post "/tax_bracket/new", params: {uuid: user.uuid, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys
      failure_message = {:message=>"Missing information to create new bracket; please include a lowest_amount and a percentage", :existing_tax_brackets=>[]}
      expect(data).to eq(failure_message)
    end

    it "creates bracket" do
      user = User.create!(tax_brackets: [])
      post "/tax_bracket/new", params: {uuid: user.uuid, lowest_amount: 10000, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:newest_bracket]["lowest_amount"]).to eq(10000)
      expect(data[:newest_bracket]["percentage"]).to    eq(0.1)

      user = User.first
      expect(user.tax_brackets.count).to       eq(1)
      expect(user.tax_brackets).to             eq([{:lowest_amount=>10000, :percentage=>0.1}])

      get "/taxable_income", params: {uuid: user.uuid, amount: "9999"}
      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to eq(0)

      get "/taxable_income", params: {uuid: user.uuid, amount: "11000"}
      data = JSON.parse(response.body).symbolize_keys
      expect(data[:tax_owed]).to eq(100)
    end

    it "won't duplicate bracket" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])

      post "/tax_bracket/new", params: {uuid: user.uuid, lowest_amount: 10000, percentage: 50}

      data = JSON.parse(response.body).symbolize_keys
      expect(data[:message]).to eq("Another tax bracket is already using 10000 as lowest limit")
    end
  end

  describe "UPDATE" do

    it "needs a lowest_amount" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])

      post "/tax_bracket/update", params: {uuid: user.uuid, bracket_id: 0, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys
      failure_message = "Missing information to update a tax bracket; please include a lowest_amount, a percentage and the id of the bracket to update"
      expect(data[:message]).to eq(failure_message)
    end

    it "needs a percentage" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])

      post "/tax_bracket/update", params: {uuid: user.uuid, lowest_amount: 1000, bracket_id: 0}

      data = JSON.parse(response.body).symbolize_keys
      failure_message = "Missing information to update a tax bracket; please include a lowest_amount, a percentage and the id of the bracket to update"
      expect(data[:message]).to eq(failure_message)
    end

    it "needs a bracket_id" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])

      post "/tax_bracket/update", params: {uuid: user.uuid, lowest_amount: 1000, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys
      failure_message = "Missing information to update a tax bracket; please include a lowest_amount, a percentage and the id of the bracket to update"
      expect(data[:message]).to eq(failure_message)
    end

    it "will update a bracket" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])
      post "/tax_bracket/update", params: {uuid: user.uuid, bracket_id: 1, lowest_amount: 29999, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys

      user = User.first
      expect(user.tax_brackets).to eq([{:lowest_amount=>29999, :percentage=>0.1}, {:lowest_amount=>10000, :percentage=>10}])
    end

    it "resists duplication" do
      user = User.create!(tax_brackets: [{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])
      post "/tax_bracket/update", params: {uuid: user.uuid, bracket_id: 0, lowest_amount: 20000, percentage: 10}

      data = JSON.parse(response.body).symbolize_keys

      user = User.first
      expect(user.tax_brackets).to eq([{lowest_amount: 10000, percentage: 10}, {lowest_amount: 20000, percentage: 20}])
      expect(data[:message]).to eq("Another tax bracket is already using 20000 as lowest limit. If you wish to update that bracket use the bracket_id.")
    end
  end
end
