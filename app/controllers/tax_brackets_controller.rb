class TaxBracketsController < ApplicationController

  def show
    uuid = params[:uuid]
    user = User.find_by(uuid: uuid)
    render json: {
      tax_brackets: user.tax_brackets
    }
  end

  def new
    uuid = params[:uuid]
    user = User.find_by(uuid: uuid)

    lowest_limit = params[:lowest_amount].to_i
    percentage =   params[:percentage].to_f/100
    new_tier = { lowest_amount: lowest_limit, percentage: percentage }

    existing_limits = user.tax_brackets.map{ |hsh| hsh[:lowest_amount] }

    if existing_limits.include?(lowest_limit)
      render json: {
        message: "Another tax bracket is already using #{lowest_limit} as lowest limit",
        existing_tax_brackets: user.tax_brackets
      }, status: 403

    else
      user.tax_brackets << new_tier
      user.tax_brackets.sort_by! { |hsh| hsh[:lowest_amount] }.reverse!
      if user.save
        render json: { user: user }
      else
        render json: { message: "Couldn't save" }, status: 403
      end
    end

  end

end
