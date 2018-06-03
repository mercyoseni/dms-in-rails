class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  # called before every action on controller
  before_action :authorize_request, except: :not_found

  attr_reader :current_user

  def not_found
    response = { message: Message.invalid_resource }
    json_response(response, 400)
  end

  private

  # check for valid token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
