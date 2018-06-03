module Response
  def json_response(response, status = :ok)
    render json: response, status: status
  end
end
