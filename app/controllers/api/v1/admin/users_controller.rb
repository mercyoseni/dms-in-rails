class Api::V1::Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :check_password_params, only: :update

  def index
    users = User.all.order('created_at ASC').as_json(except: :password_digest)
    response = { message: Message.loaded_users, data: users }
    json_response(response)
  end

  def show
    @user = @user.as_json(except: :password_digest)
    response = { message: Message.loaded_user, data: @user }
    json_response(response)
  end

  def create
    # returns user token when an admin creates a user
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.created_user, auth_token: auth_token }
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

  def require_admin
    raise ExceptionHandler::Forbidden unless current_user.role == 'admin'
  end

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
    @user = User.find(params[:id])
  end

  def check_password_params
    raise(ExceptionHandler::PasswordNotBlank) if params[:password] && params[:password].blank?
  end
end
