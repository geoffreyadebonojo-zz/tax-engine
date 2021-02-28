class UsersController < ApplicationController

  def show
    user = User.find_by(uuid: params[:uuid])
    if user.present?
      render json: { user: user }, status: 200
    else
      render json: { message: "Please enter a valid uuid" }, status: 400
    end
  end

  def new
    user = User.create!()
    render json: {
      user: user,
      message: "You have successfully created a user."
    }, status: 201
  end

end
