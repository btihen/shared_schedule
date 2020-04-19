class Category < ApplicationRecord

  belongs_to :tenant

  has_many :events, dependent: :destroy

  has_many :user_interests, inverse_of: :category, dependent: :destroy
  has_many :users, through: :user_interests

  validates :tenant,     presence: true
  validates :category_name, presence: true

end
