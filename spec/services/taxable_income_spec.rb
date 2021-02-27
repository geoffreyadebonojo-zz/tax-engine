require 'rails_helper'

describe "TaxableIncome" do
  describe 'calculate_total_amount' do
    describe 'basic functionality' do
      before :each do
        csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/basic_functionality_test.csv"
        @taxable_income = TaxableIncome.new(csv_path)
      end

      describe '#calculate_total_amount' do
        it 'test_0_to_10k' do
          expect(@taxable_income.calculate_total_amount(0)).to eq(0)
          expect(@taxable_income.calculate_total_amount(5000)).to eq(0)
          expect(@taxable_income.calculate_total_amount(10000)).to eq(0)
        end

        it 'test_10k_to_20k' do
          expect(@taxable_income.calculate_total_amount(10001)).to eq(0.10)
          expect(@taxable_income.calculate_total_amount(15000)).to eq(500.00)
          expect(@taxable_income.calculate_total_amount(20000)).to eq(1000.00)
          expect(@taxable_income.calculate_total_amount(35000)).to eq(4000.00)
          expect(@taxable_income.calculate_total_amount(50000)).to eq(7000.00)
        end

        it 'test_20k_to_50k' do
          expect(@taxable_income.calculate_total_amount(50001)).to eq(7000.30)
          expect(@taxable_income.calculate_total_amount(65000)).to eq(11500.00)
          expect(@taxable_income.calculate_total_amount(100000)).to eq(22000.00)
        end

        it "can handle weird zeros" do
          csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/weird_zeros_test.csv"
          taxable_income = TaxableIncome.new(csv_path)
          expect(taxable_income.calculate_total_amount(5000)).to eq(0.0)
          expect(taxable_income.calculate_total_amount(15000)).to eq(500.00)
          expect(taxable_income.calculate_total_amount(25000)).to eq(1000.00)
          expect(taxable_income.calculate_total_amount(35000)).to eq(1000.00)
          expect(taxable_income.calculate_total_amount(45000)).to eq(1000.00)
          expect(taxable_income.calculate_total_amount(65000)).to eq(5500.00)
        end

        it 'can handle out of order arrays' do
          csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/out_of_order_test.csv"
          taxable_income = TaxableIncome.new(csv_path)
          expect(taxable_income.calculate_total_amount(10001)).to eq(0.10)
          expect(taxable_income.calculate_total_amount(15000)).to eq(500.00)
          expect(taxable_income.calculate_total_amount(20000)).to eq(1000.00)
          expect(taxable_income.calculate_total_amount(35000)).to eq(4000.00)
          expect(taxable_income.calculate_total_amount(50000)).to eq(7000.00)
          expect(taxable_income.calculate_total_amount(100010)).to eq(22005.00)
        end
      end
    end

    describe 'can handle extended range' do
      it 'test_50k_to_100k' do
        csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/extended_range_test.csv"
        taxable_income = TaxableIncome.new(csv_path)
        expect(22005.00).to eq(taxable_income.calculate_total_amount(100010))
      end
    end

  end
end
