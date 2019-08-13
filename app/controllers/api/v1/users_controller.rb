class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :is_current_user, only: [:update, :destroy]
  before_action :check_password_params, only: :update

  def index
    users = User.refined_users
    serialized_users =
      users.map { |user| Api::V1::UserResource.new(user, nil) }
    response = JSONAPI::ResourceSerializer.new(
      Api::V1::UserResource,
      fields: {
        users: [:firstname, :lastname, :email]
      }
    ).serialize_to_hash(serialized_users)

    json_response(response)
  end

  def show
    if current_user.id.to_s == params[:id]
      user = User.find(params[:id])
      response = JSONAPI::ResourceSerializer.new(Api::V1::UserResource)
        .serialize_to_hash(Api::V1::UserResource.new(user, nil))
    else
      user = User.refined_users.find(params[:id])
      response = JSONAPI::ResourceSerializer.new(
        Api::V1::UserResource,
        fields: {
          users: [:firstname, :lastname, :email]
        }
      ).serialize_to_hash(Api::V1::UserResource.new(user, nil))
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
    @user.update_attributes!(user_params)
    response = JSONAPI::ResourceSerializer.new(Api::V1::UserResource)
      .serialize_to_hash(Api::V1::UserResource.new(@user, nil))

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
    if current_user.id.to_s != params[:id]
      raise(ExceptionHandler::Forbidden)
    end

    @user = current_user
  end

  def check_password_params
    if params[:data][:attributes][:password] &&
      params[:data][:attributes][:password].blank?
      raise(ExceptionHandler::PasswordNotBlank)
    end
  end
end
