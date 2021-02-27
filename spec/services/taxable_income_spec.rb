require 'rails_helper'

describe "TaxableIncome" do
  describe 'calculate_total_amount' do
    describe 'basic functionality' do
      before :each do
        limits = [{limit: 50000,  percentage: 0.3},
                  {limit: 10000,  percentage: 0.1},
                  {limit: 20000,  percentage: 0.2},
                  {limit: 0,      percentage: 0.0}]
        @taxable_income = TaxableIncome.new(limits)
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
      end
    end

    describe 'extended functionality' do
      it 'test_50k_to_100k' do
        # skip "extends bracket range"
        limits = [{limit: 100000, percentage: 0.5},
                  {limit: 50000,  percentage: 0.3},
                  {limit: 20000,  percentage: 0.2},
                  {limit: 10000,  percentage: 0.1},
                  {limit: 0,      percentage: 0.0}]
        taxable_income = TaxableIncome.new(limits)
        expect(22005.00).to eq(taxable_income.calculate_total_amount(100010))
      end

      it 'test_limits_array_out_of_order' do
        limits = [{limit: 0,      percentage: 0.0},
                  {limit: 100000, percentage: 0.5},
                  {limit: 20000,  percentage: 0.2},
                  {limit: 10000,  percentage: 0.1},
                  {limit: 50000,  percentage: 0.3}]
        taxable_income = TaxableIncome.new(limits)
        expect(taxable_income.calculate_total_amount(10001)).to eq(0.10)
        expect(taxable_income.calculate_total_amount(15000)).to eq(500.00)
        expect(taxable_income.calculate_total_amount(20000)).to eq(1000.00)
        expect(taxable_income.calculate_total_amount(35000)).to eq(4000.00)
        expect(taxable_income.calculate_total_amount(50000)).to eq(7000.00)
        expect(taxable_income.calculate_total_amount(100010)).to eq(22005.00)
      end
    end
    
  end
end
