class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
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

  # DRY JSONAPI::ResourceSerializer
  def resource_serializer(resource, data, option={})
    resource_instance = Array.wrap(data).map do |instance|
      resource.new(instance, nil)
    end

    JSONAPI::ResourceSerializer.new(resource, option)
      .serialize_to_hash(resource_instance)
  end
end
