class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :is_current_user, only: [:update, :destroy]
  before_action :check_password_params, only: :update

  def index
    response = resource_serializer(
      resource,
      User.refined_users,
      { fields: { users: [:firstname, :lastname, :email] } },
    )

    json_response(response)
  end

  def show
    if current_user.id.to_s == params[:id]
      user = User.find(params[:id])
      response = resource_serializer(resource, user)
    else
      user = User.refined_users.find(params[:id])
      response = resource_serializer(
        resource,
        user,
        { fields: { users: [:firstname, :lastname, :email] } }
      )
    end

    json_response(response)
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
    current_user.update_attributes!(user_params)
    response = resource_serializer(resource, current_user)

    json_response(response)
  end

  private

  def resource
    Api::V1::UserResource
  end

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
    if current_user.id.to_s != params[:id]
      raise(ExceptionHandler::Forbidden)
    end

    current_user
  end

  def check_password_params
    if params[:data][:attributes][:password] &&
      params[:data][:attributes][:password].blank?
      raise(ExceptionHandler::PasswordNotBlank)
    end
  end
end
