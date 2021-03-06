class Tag < ApplicationRecord
  has_many :taggings
  has_many :records, through: :taggings
  belongs_to :user

  validates_presence_of :name
  validates_length_of :name, maximum: 20, if: :name
end
