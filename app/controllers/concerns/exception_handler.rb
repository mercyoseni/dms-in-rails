module ExceptionHandler
  extend ActiveSupport::Concern

  # define custom error subclasses - rescue catches StandardErrors
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable_entity
  def four_twenty_two(e)
    message = e.message

    case message
    when /Access is not included/
      message = "Access must be any of 'private', 'public' or 'role_based'"
    end

    json_response({ message: message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end
end
