class Api::V1::UsersController < ApplicationController
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
    user = User.new(user_params)

    if user.save
      render json: {
        status: 'SUCCESS',
        message: 'Created user',
        data: user
      }, status: :ok
    else
      render json: {
        status: 'ERROR',
        message: 'User not created',
        data: user.errors
      }, status: :unprocessable_entity
    end
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
    params.permit(:firstname, :lastname, :email, :role)
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
