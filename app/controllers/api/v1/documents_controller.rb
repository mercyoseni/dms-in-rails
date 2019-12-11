class Api::V1::DocumentsController < ApplicationController
  before_action :find_document, only: [:show, :update, :destroy]
  before_action :is_current_user_document, only: [:update, :destroy]

  def index
    response = resource_serializer(resource, accessible_documents)

    json_response(response)
  end

  def show
    response = resource_serializer(resource, @document)
    json_response(response)
  end

  def create
    # create documents belonging to a user
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

  def get_related_resources
    # Display only public or role_based docs to current_user
    user_documents = User.find(params[:user_id]).documents
    documents = []

    accessible_documents.map do |document|
      documents << document if user_documents.include?(document)
    end

    response = resource_serializer(resource, documents)

    json_response(response)
  end

  private

  def accessible_documents
    current_user_and_public_documents + current_user_role_based_documents
  end

  def is_current_user_document
    if @document.user_id != current_user.id
      raise ExceptionHandler::Forbidden
    end
  end

  def find_document
    @document = current_user_and_public_documents.find(params[:id]) ||
      current_user_role_based_documents.find(params[:id])
  end

  def document_params
    params.require(:data).require(:attributes).permit(:title, :body, :access)
  end

  def resource
    Api::V1::DocumentResource
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
