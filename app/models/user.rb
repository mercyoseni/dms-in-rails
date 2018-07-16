class User < ApplicationRecord
  has_secure_password

  has_many :documents, dependent: :destroy

  validates_presence_of :firstname, :lastname, :email
  validates_uniqueness_of :email
  validates_length_of :email, in: 6..50
  validates_length_of :password, in: 6..20, if: :password
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_create :set_role

  private

  def set_role
    self.role = %w(regular author contributor).sample
  end
end
