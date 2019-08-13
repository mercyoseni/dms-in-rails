class Api::V1::DocumentResource < Api::V1::ApplicationResource
  model_name 'Document'

  attributes :title, :body, :access, :created_at, :updated_at
  has_one :user
  filters :title, :body, :access
end
