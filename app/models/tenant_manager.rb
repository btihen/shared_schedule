class TenantManager < ApplicationRecord

  belongs_to :tenant
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'

  validates :tenant,  presence: true
  validates :manager, presence: true

end
