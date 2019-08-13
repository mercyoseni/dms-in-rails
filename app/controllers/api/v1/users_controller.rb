class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :is_current_user, only: [:update, :destroy]
  before_action :check_password_params, only: :update

  def index
    @users = User.select('id, firstname, lastname, email').order('created_at ASC')
    response = { message: Message.loaded_users, data: @users }
    json_response(response)
  end

  def show
    if current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
      response = { message: Message.loaded_user, data: @user }
      json_response(response)
    else
      @user = User.select('id, firstname, lastname, email').find(params[:id])
      response = { message: Message.loaded_user, data: @user }
      json_response(response)
    end
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
    @user.update_attributes!(user_params)
    response = { message: Message.updated_user, data: @user }
    json_response(response)
  end

  def destroy
    @user.destroy
    response = { message: Message.deleted_user }
    json_response(response)
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(
      :firstname,
      :lastname,
      :email,
      :password,
      :password_confirmation
    )
  end

  def is_current_user
    raise(ExceptionHandler::Forbidden) unless @current_user.id.to_s == params[:id]
    @user = @current_user
  end

  def check_password_params
    raise(ExceptionHandler::PasswordNotBlank) if params[:password] && params[:password].blank?
  end
end
