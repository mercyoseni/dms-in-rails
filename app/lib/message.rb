class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end

  def self.invalid_resource
    'Invalid resource'
  end

  def self.loaded_documents
    'Loaded documents successfully'
  end

  def self.loaded_document
    'Loaded document successfully'
  end

  def self.created_document
    'Created document(s) successfully'
  end

  def self.updated_document
    'Updated document successfully'
  end

  def self.document_not_updated
    'Document could not be updated'
  end

  def self.deleted_document
    'Deleted document successfully'
  end

  def self.not_allowed
    'You are not allowed to alter the document id or user_id'
  end

  def self.loaded_users
    'Loaded users successfully'
  end

  def self.loaded_user
    'Loaded user successfully'
  end

  def self.updated_user
    'Updated user successfully'
  end

  def self.deleted_user
    'Deleted user successfully'
  end

  def self.forbidden
    'You are not allowed to perform this action'
  end

  def self.created_user
    'Created user successfully'
  end

  def self.no_documents
    'User has no documents'
  end
end
