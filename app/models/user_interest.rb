class UserInterest < ApplicationRecord

  belongs_to :user
  belongs_to :category  # a user is interested in categories

  validates :user,     presence: true
  validates :category, presence: true
end
