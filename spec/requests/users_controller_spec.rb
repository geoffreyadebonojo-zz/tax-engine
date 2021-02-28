require 'rails_helper'

describe "UsersController", type: :request do
  describe "GET" do
    it "requires uuid to show user data" do
      user = User.create!()
      get '/user', params: {}

      data = JSON.parse(response.body).symbolize_keys

      expect(data[:message]).to eq("Please enter a valid uuid")
    end

    it "requires the correct uuid to show user data" do
      user = User.create!(uuid:   "9b44abb039da2fec8bbb")
      get '/user', params: {uuid: "2sdkjr12wekjnnfbuioq"}

      data = JSON.parse(response.body).symbolize_keys

      expect(data[:message]).to eq("Please enter a valid uuid")
    end

    it "shows existing user with correct uuid" do
      user = User.create!()
      get '/user', params: {uuid: user.uuid}

      data = JSON.parse(response.body).symbolize_keys

      expect(data[:user]["uuid"]).to eq(User.first.uuid)
    end
  end

  describe "CREATE" do
    it "creates a new user" do
      post '/user/new', params: {}

      data = JSON.parse(response.body).symbolize_keys

      expect(data[:message]).to eq("You have successfully created a user.")

      expect(data[:user]["uuid"]).to eq(User.first.uuid)
      expect(User.count).to eq(1)
    end
  end
end
