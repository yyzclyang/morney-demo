class User < ApplicationRecord
  has_many :records
  has_many :tags
  has_many :taggings

  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :email
  # password 的检测 has_secure_password 做了
  validates_presence_of :password_confirmation, on: [:create]

  validates_format_of :email, with: /.+@.+/, if: Proc.new { |u| u.email.present? }
  validates_length_of :password, minimum: 6, on: [:create], if: :password

  after_create :send_welcome_email

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
