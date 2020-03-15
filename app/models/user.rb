class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  belongs_to :tenant

  has_many :user_interests, inverse_of: :user, dependent: :destroy
  has_many :interests, through: :user_interests, source: :reason

  validates :tenant,      presence: true
  validates :last_name,   presence: true
  validates :first_name,  presence: true
  validates :password,    presence: true, on: :create
  validates :password,    length:   { in: 8..32,
                                      message: 'Length must be between 8-32 characters long' },
                          if: Proc.new { |u| u.password.present? }
                          # if: :password_present?  # if: -> { |u| u.password.present? }
  validates :email,       presence: true, uniqueness: true,
                          format: { with: Devise::email_regexp }
  validates :user_role,   presence: true,
                          inclusion: { in: ApplicationHelper::USER_ROLES } #,
                                      # message: "%{value} is not a valid user_role"}

  validate  :validate_password_complexity

  def guest?
    id.blank?
  end

  def may_edit?
    %w[manager scheduler].include? user_role
  end

  private

  def password_present?
    password.present?
  end

  def validate_password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    # return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,30}$/
    return if password.nil? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,32}$/

    error_message = 'complexity requirement not met. Length should be 8-32 characters and include at least: 1 uppercase, 1 lowercase and 1 digit'
    errors.add :password, error_message
    # https://stackoverflow.com/questions/46727879/how-to-check-if-password-satisfies-devise-validation-requirements
    # Devise.password_length.include?(user[:password].length)
  end

end
