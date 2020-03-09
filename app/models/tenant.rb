class Tenant < ApplicationRecord

  has_many :events,     inverse_of: :tenant, dependent: :destroy
  has_many :spaces,     inverse_of: :tenant, dependent: :destroy
  has_many :reasons,    inverse_of: :tenant, dependent: :destroy
  has_many :users,      inverse_of: :tenant, dependent: :destroy
  has_many :time_slots, inverse_of: :tenant, dependent: :destroy

  validates :tenant_name, presence: true

  def is_publicly_viewable?
    is_publicly_viewable
  end

end
