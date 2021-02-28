require 'rails_helper'

RSpec.describe User, type: :model do

  describe "#create" do
    before :each do
      @custom_uuid = "12345689a"
      csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/basic_functionality_test.csv"
      @tax_brackets = CSVParser.execute(csv_path)
    end

    it "allows custom uuid" do
      user = User.create!(uuid: @custom_uuid, tax_brackets: @tax_brackets)
      expect(user.uuid).to eq("12345689a")
    end

    it "generates random uuid" do
      user = User.create!(tax_brackets: @tax_brackets)
      expect(user.uuid).to_not eq("12345689a")
    end

    it "serializes brackets data" do
      user = User.create!(tax_brackets: @tax_brackets)
      brackets = [{:lowest_amount=>50000, :percentage=>0.3},
                  {:lowest_amount=>20000, :percentage=>0.2},
                  {:lowest_amount=>10000, :percentage=>0.1},
                  {:lowest_amount=>0, :percentage=>0.0}]
      # kinda redundant but why not?
      expect(user.tax_brackets).to be_instance_of(Array)
      expect(user.tax_brackets).to eq(brackets)
    end
  end
end
