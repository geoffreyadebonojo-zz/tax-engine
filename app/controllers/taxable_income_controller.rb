class TaxableIncomeController < ApplicationController

  def show
    amount = params[:amount].to_i

    if amount < 1
      render json: {
        message: "amount must be a number above 0",
        status: 404
      }
    else
      limits = [{limit: 49999,  percentage: 0.3},
                {limit: 19999,  percentage: 0.1},
                {limit: 9999,   percentage: 0.2},
                {limit: 0,      percentage: 0.0}]
      taxable_income = TaxableIncome.new(limits)
      render json: {
        taxes_owed: taxable_income.calculate_total_amount(amount),
        status: 200
      }
    end
  end

end
