class User < ApplicationRecord
  has_many :documents

  validates_presence_of :firstname, :lastname, :email, :role
  validates_inclusion_of :role, in: %w(admin regular author contributor)
  validates_uniqueness_of :email
  validates_length_of :email, in: 6..50
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
