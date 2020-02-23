class Reason < ApplicationRecord

  belongs_to :tenant

  has_many :events, dependent: :destroy

  has_many :user_interests, inverse_of: :reason, dependent: :destroy
  has_many :users, through: :user_interests, dependent: :destroy

  validates :tenant,     presence: true
  validates :reason_name, presence: true

end
