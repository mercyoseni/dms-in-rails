class Api::V1::ApplicationResource < JSONAPI::Resource
  # An optional Meta object added to every request
  def meta(options)
    { copyright: "© #{ Time.now.year } MDS - MeekDocMgtSystem, Inc." }
  end
end
