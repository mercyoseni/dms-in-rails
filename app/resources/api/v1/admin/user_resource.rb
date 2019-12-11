class Api::V1::Admin::UserResource < Api::V1::ApplicationResource
  model_name 'User'

  attributes :firstname, :lastname, :email, :role, :created_at, :updated_at
  has_many :documents
end
