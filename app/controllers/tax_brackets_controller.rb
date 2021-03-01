class TaxBracketsController < ApplicationController

  before_action :find_user

  def show
    render json: {
      tax_brackets: @user.tax_brackets
    }
  end

  def new
    new_bracket_limit = params[:lowest_amount]
    if bracket_already_exists?(new_bracket_limit)
      already_existing_response(new_bracket_limit)
    elsif insufficient_create_params?(params)
      missing_create_information_response
    else
      create_new_bracket(params)
    end
  end

  def update
    if insufficient_update_params?(params)
      missing_update_information_response
    else
      update_existing_bracket(params)
    end
  end

  def destroy
    if insufficient_delete_params?(params)
      bracket_not_found_response
    else
      delete_existing_bracket(params)
    end
  end

  private

  def insufficient_create_params?(params)
    params[:lowest_amount].nil? || params[:percentage].nil?
  end

  def insufficient_update_params?(params)
    params[:lowest_amount].nil? || params[:percentage].nil? || params[:bracket_id].nil?
  end

  def insufficient_delete_params?(params)
    params[:bracket_id].nil?
  end

  def missing_create_information_response
    render json: {
      message: "Missing information to create new bracket; please include a lowest_amount and a percentage",
      existing_tax_brackets: brackets_with_index
    }, status: 403
  end

  def missing_update_information_response
    render json: {
      message: "Missing information to update a tax bracket; please include a lowest_amount, a percentage and the id of the bracket to update",
      existing_tax_brackets: brackets_with_index
    }, status: 403
  end

  def bracket_not_found_response
    render json: {
      message: "Can't find that tax bracket in the list",
      existing_tax_brackets: brackets_with_index
    }, status: 403
  end

  def already_existing_response(new_bracket_limit)
    render json: {
      message: "Another tax bracket is already using #{new_bracket_limit} as lowest limit",
      existing_tax_brackets: brackets_with_index
    }, status: 403
  end

  def bracket_already_exists?(new_bracket_lowest_amount)
    existing_brackets = @user.tax_brackets.map do |hsh|
      hsh[:lowest_amount]
    end
    existing_brackets.include?(new_bracket_lowest_amount.to_i)
  end

  def brackets_with_index
    @user.tax_brackets.each_with_index.map do |hsh, index|
      hsh.merge(id: index)
    end
  end

  def newest_tax_bracket(params)
    lowest_amount = params[:lowest_amount].to_i
    percentage =   params[:percentage].to_f/100
    new_tax_bracket = { lowest_amount: lowest_amount, percentage: percentage }
  end

  def create_new_bracket(params)
    newest_tax_bracket = newest_tax_bracket(params)
    @user.tax_brackets << newest_tax_bracket
    @user.tax_brackets.sort_by! { |hsh| hsh[:lowest_amount] }.reverse!
    if @user.save
      render json: {
        newest_bracket: newest_tax_bracket,
        user: @user
      }, status: 200
    else
      render json: {
        message: "Couldn't save"
      }, status: 403
    end
  end

  def update_existing_bracket(params)
    bracket_index = params[:bracket_id].to_i
    new_bracket_lowest_amount = params[:lowest_amount].to_i
    target_bracket_amount = @user.tax_brackets[bracket_index][:lowest_amount]

    # prevents us from updating a bracket with an already existing bracket amount
    if bracket_already_exists?(new_bracket_lowest_amount) && target_bracket_amount != new_bracket_lowest_amount
      render json: {
        message: "Another tax bracket is already using #{new_bracket_lowest_amount} as lowest limit. If you wish to update that bracket use the bracket_id.",
        existing_tax_brackets: brackets_with_index
      }, status: 403

    else
      new_tier = newest_tax_bracket(params)
      @user.tax_brackets[bracket_index] = new_tier
      @user.tax_brackets.sort_by! { |hsh| hsh[:lowest_amount] }.reverse!
      if @user.save
        render json: {
          updated_bracket: new_tier,
          existing_tax_brackets: brackets_with_index
        }, status: 200
      else
        render json: {
          message: "Couldn't save",
          newest_bracket: new_tier
        }, status: 403
      end
    end
  end

  def delete_existing_bracket(params)
    bracket_index = params[:bracket_id].to_i
    target_bracket = @user.tax_brackets[bracket_index]

    if target_bracket.present?
      @user.tax_brackets.delete_at(bracket_index)
      @user.save
      render json: {
        deleted_bracket: target_bracket,
        message: "Tax bracket successfully deleted",
        user: @user
      }, status: 200
    else
      render json: {
        message: "Couldn't find a tax bracket with id #{bracket_index}"
      }, status: 403
    end
  end

  def find_user
    @user = User.find_by(uuid: params[:uuid])
  end

end
