class Api::V1::DocumentsController < ApplicationController
  before_action :find_user
  before_action :check_params, only: [:update]
  before_action :find_document, only: [:show, :update, :destroy]

  def index
    documents = @user.documents.order('created_at ASC')

    render json: {
      status: 'SUCCESS',
      message: 'Loaded documents',
      data: documents
    }, status: :ok
  end

  def show
    render json: {
      status: 'SUCCESS',
      message: 'Loaded document',
      data: @document
    }, status: :ok
  end

  def create
    document = Document.new(document_params)

    if document.save
      render json: {
        status: 'SUCCESS',
        message: 'Created document',
        data: document,
      }, status: :ok
    else
      render json: {
        status: 'ERROR',
        message: 'Document not created',
        data: document.errors,
      }, status: :unprocessable_entity
    end
  end

  def update
    if @document.update_attributes(document_params)
      render json: {
        status: 'SUCCESS',
        message: 'Updated document',
        data: @document
      }, status: :ok
    else
      render json: {
        status: 'ERROR',
        data: @document.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    render json: {
      status: 'SUCCESS',
      message: 'Deleted document',
    }, status: :ok
  end

  private

  def find_user
    begin
      @user = User.find(params[:user_id])
    rescue
      render json: {
        status: 'ERROR',
        message: 'User does not exist',
      }, status: :unprocessable_entity
    end
  end

  def find_document
    begin
      @document = @user.documents.find(params[:id])
    rescue
      render json: {
        status: 'ERROR',
        message: 'Document does not exist',
      }, status: :unprocessable_entity
    end
  end

  def document_params
    params.permit(:title, :body, :access, :user_id)
  end

  def check_params
    if params[:document][:id] || params[:document][:user_id]
      render json: {
        status: 'FORBIDDEN',
        message: 'You are not allowed to alter the document id or user_id'
      }, status: :unprocessable_entity
    end
  end
end
