class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email
  # password 的检测 has_secure_password 做了
  validates_presence_of :password_confirmation, on: [:create]

  validates_format_of :email, with: /.+@.+/
  validates_length_of :password, minimum: 6, on: [:create]
end
