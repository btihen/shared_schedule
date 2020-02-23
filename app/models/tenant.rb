class Tenant < ApplicationRecord

  # destroy join tables before base models for depenent destroy to work
  has_many :tenant_managers, inverse_of: :tenant, dependent: :destroy
  has_many :managers, through: :tenant_managers, source: :manager
  # after_destroy :remove_managers_before_destroy
  # before_destroy :remove_managers_before_destroy, prepend: true

  has_many :events, inverse_of: :tenant, dependent: :destroy
  has_many :spaces, inverse_of: :tenant, dependent: :destroy
  has_many :reasons, inverse_of: :tenant, dependent: :destroy
  has_many :users,  inverse_of: :tenant, dependent: :destroy

  validates :tenant_name, presence: true

  private

  def remove_managers_before_destroy
    managers.destroy_all
    # managers.each do |user|
    #   user.destroy
    # end
  end

end
