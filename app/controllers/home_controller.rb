class HomeController < ActionController::Base
  def index
    respond_to do |format|
      format.json { render json: { message: 'Welcome to DMS api'} }
      format.html { render file: 'public/home.html' }
    end
  end
end
