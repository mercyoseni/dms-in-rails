class Api::V1::Admin::DocumentsController < ApplicationController
  before_action :require_admin
  before_action :find_document, only: [:show, :update, :destroy]
  before_action :find_user, only: [:user_documents]

  def index
    response = resource_serializer(resource, Document.admin_documents)
    json_response(response)
  end

  def show
    response = resource_serializer(resource, @document)
    json_response(response)
  end

  def create
    document = current_user.documents.create!(document_params)
    response = resource_serializer(resource, document)

    json_response(response, :created)
  end

  def update
    @document.update_attributes!(document_params)
    response = resource_serializer(resource, @document)

    json_response(response)
  end

  def destroy
    @document.destroy
  end

  # enable admin to view a specific user's documents
  def user_documents
    documents = @user.documents.order('created_at ASC')
    response = resource_serializer(resource, documents)

    json_response(response)
  end

  private

  def resource
    Api::V1::Admin::DocumentResource
  end

  def require_admin
    if current_user.role != 'admin'
      raise ExceptionHandler::Forbidden
    end
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:data).require(:attributes).permit(:title, :body, :access)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end
