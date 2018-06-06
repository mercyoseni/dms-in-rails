class Api::V1::Admin::DocumentsController < ApplicationController
  before_action :find_document, only: [:show, :update, :destroy]

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

  private

  def find_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.permit(:title, :body, :access)
  end
end
