class Api::V1::DocumentsController < ApplicationController
  before_action :find_document, only: [:show, :update, :destroy]
  before_action :check_params, only: [:update]

  def index
    @documents = current_user.documents.order('created_at ASC')
    response = { message: Message.loaded_documents, data: @documents }
    json_response(response)
  end

  def show
    response = { message: Message.loaded_documents, data: @document }
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

  def find_document
    begin
      @document = current_user.documents.find(params[:id])
    rescue
      response = { message: Message.not_found }
      json_response(response, :unprocessable_entity)
    end
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
end
