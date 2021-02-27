class TaxableIncomeController < ApplicationController

  def show
    amount = params[:amount].to_i

    # for demonstration purposes. Production data would use user-provided CSV data
    csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/basic_functionality_test.csv"

    if amount < 1
      render json: { message: "amount must be a number above 0" }, status: 422
    else
      taxable_income = TaxableIncome.new(csv_path)
      render json: { tax_owed: taxable_income.calculate_total_amount(amount) }, status: 200
    end
  end

end
