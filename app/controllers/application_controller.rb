class ApplicationController < ActionController::API
  def not_found
    render json: {
      message: 'Invalid resource'
    }, status: 400
  end
end
