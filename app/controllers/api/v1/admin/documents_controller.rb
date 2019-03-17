class Api::V1::Admin::DocumentsController < ApplicationController
  before_action :require_admin
  before_action :find_document, only: [:show, :update, :destroy]
  before_action :find_user, only: [:user_documents]

  def index
    documents = Document.all.order('created_at ASC')
    response = { message: Message.loaded_documents, data: documents }
    json_response(response)
  end

  def show
    response = { message: Message.loaded_document, data: @document }
    json_response(response)
  end

  def create
    document = current_user.documents.create!(document_params)
    response = { message: Message.created_document, data: document }
    json_response(response)
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

  # enable admin to view a specific user's documents
  def user_documents
    documents = @user.documents.order('created_at ASC')

    if documents.size > 0
      response = { message: Message.loaded_documents, data: documents }
    else
      response = { message: Message.no_documents }
    end

    json_response(response)
  end

  private

  def require_admin
    raise ExceptionHandler::Forbidden unless current_user.role == 'admin'
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.permit(:title, :body, :access)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
