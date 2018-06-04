module ExceptionHandler
  extend ActiveSupport::Concern

  # define custom error subclasses - rescue catches StandardErrors
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class Forbidden < StandardError; end
  class PasswordNotBlank < StandardError; end

  included do
    # define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound, with: :four_zero_four
    rescue_from ExceptionHandler::Forbidden, with: :four_zero_three
    rescue_from ExceptionHandler::PasswordNotBlank, with: :four_twenty_two
  end

  private

  # JSON response with message; Status code 422 - unprocessable_entity
  def four_twenty_two(e)
    message = e.message

    case message
    when /Access is not included/
      message = "Access must be any of 'private', 'public' or 'role_based'"

    when /PasswordNotBlank/
      message = "Password can't be blank"
    end

    json_response({ message: message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end

  def four_zero_four
    json_response({ message: Message.not_found }, :not_found)
  end

  def four_zero_three
    json_response({ message: Message.forbidden }, 403)
  end
end
