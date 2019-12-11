class Api::V1::Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :check_password_params, only: :update

  def index
    response = resource_serializer(resource, User.admin_users)
    json_response(response)
  end

  def show
    response = resource_serializer(resource, @user)
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
    response = resource_serializer(resource, @user)

    json_response(response)
  end

  def destroy
    @user.destroy
  end

  def get_related_resource
    user = Document.find(params[:document_id]).user
    response = resource_serializer(resource, user)

    json_response(response)
  end

  private

  def resource
    Api::V1::Admin::UserResource
  end

  def require_admin
    if current_user.role != 'admin'
      raise ExceptionHandler::Forbidden
    end
  end

  def user_params
    params.require(:data).require(:attributes).permit(
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
    if params[:data][:attributes][:password] &&
      params[:data][:attributes][:password].blank?
    raise(ExceptionHandler::PasswordNotBlank)
    end
  end
end
