class Document < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :body, :access, :user
  validates_inclusion_of :access, in: %w(public private role_based)
  validates_length_of :title, :body, in: 5..100
end
