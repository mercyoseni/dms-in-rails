class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :find_user, only: [:show, :update, :destroy]

  def index
    users = User.all.order('created_at ASC')

    render json: {
      status: 'SUCCESS',
      message: 'Loaded users',
      data: users
    }, status: :ok
  end

  def show
    render json: {
      status: 'SUCCESS',
      message: 'Loaded user',
      data: @user
    }, status: :ok
  end

  def create
    # POST /signup
    # return authenticated token upon signup
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def update
    if @user.update_attributes(user_params)
      render json: {
        status: 'SUCCESS',
        message: 'Updated user',
        data: @user
      }, status: :ok
    else
      render json: {
      status: 'ERROR',
      message: 'User not updated',
      data: @user.errors
    }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: {
      status: 'SUCCESS',
      message: 'Deleted user',
    }, status: :ok
  end

  private

  def user_params
    params.permit(
      :firstname,
      :lastname,
      :email,
      :role,
      :password,
      :password_confirmation
    )
  end

  def find_user
    begin
      @user = User.find(params[:id])
    rescue
      render json: {
        status: 'ERROR',
        message: 'User does not exist',
      }, status: :unprocessable_entity
    end
  end
end
