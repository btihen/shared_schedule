class UserInterest < ApplicationRecord

  belongs_to :user
  belongs_to :reason  # a user is interested in reasons

  validates :user,  presence: true
  validates :reason, presence: true
end
