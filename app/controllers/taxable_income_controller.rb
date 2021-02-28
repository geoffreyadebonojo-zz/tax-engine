class TaxableIncomeController < ApplicationController

  def show
    @amount = params[:amount].to_i
    uuid =   params[:uuid]

    if @amount < 1
      invalid_amount
    else
      if user = User.find_by(uuid: uuid)
        results_for_existing_user(user)
      else
        invalid_uuid
      end
    end

  end

  private

  def invalid_amount
    render json: {
      message: "amount must be a number above 0"
      }, status: 422
  end

  def results_for_existing_user(user)
    taxable_income = TaxableIncome.new(user.tax_brackets).calculate_total_amount(@amount)

    render json: {
      tax_owed: taxable_income,
      uuid: user.uuid
    }, status: 200
  end

  def invalid_uuid
    message = "No valid uuid was given; default tax brackets are being used. To calculate "\
      "tax information for your organization please create an account or "\
      "enter a valid uuid."
    message += dev_message if !Rails.env.production?

    render json: {
      message: message
    }, status: 400
  end

  def dev_message
    " DEVS: try using one of the uuids defined in the seed file: 9b44abb039da2fec8bbb;"
  end
end
