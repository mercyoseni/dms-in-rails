class Api::V1::DocumentsController < ApplicationController
  before_action :find_document, only: [:show, :update, :destroy]
  before_action :is_current_user_document, only: [:update, :destroy]
  before_action :check_params, only: [:update]

  def index
    @documents = current_user_and_public_documents + current_user_role_based_documents

    response = { message: Message.loaded_documents, data: @documents.uniq }
    json_response(response)
  end

  def show
    response = { message: Message.loaded_document, data: @document }
    json_response(response)
  end

  def create
    # create documents belonging to a user
    @document = current_user.documents.create!(document_params)
    response = { message: Message.created_document, data: @document }
    json_response(response, :created)
  end

  def update
    @document.update_attributes!(document_params)
    response = { message: Message.updated_document, data: @document }
    json_response(response)
  end

  def destroy
    @document.destroy
    response = { message: Message.deleted_document }
    json_response(response)
  end

  private

  def is_current_user_document
    raise ExceptionHandler::Forbidden unless @document.user_id == current_user.id
  end

  def find_document
    @document = current_user_and_public_documents.find(params[:id]) ||
                current_user_role_based_documents.find(params[:id])
  end

  def document_params
    params.permit(:title, :body, :access)
  end

  def check_params
    if params[:document][:id] || params[:document][:user_id]
      response = { message: Message.not_allowed }
      json_response(response, 403)
    end
  end

  def current_user_and_public_documents
    current_user.documents.or(
      Document.where(access: 'public')
    )
  end

  def current_user_role_based_documents
    Document.includes(:user).where(
      users: { role: current_user.role },
      access: 'role_based'
    )
  end
end
