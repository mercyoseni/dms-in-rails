class Api::V1::DocumentResource < Api::V1::ApplicationResource
  model_name 'Document'

  attributes :title, :body, :access
  has_one :user
  filters :title, :body, :access
end
