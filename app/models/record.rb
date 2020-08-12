class Record < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  enum category: {outgoings: 1, income: 2}

  validates_presence_of :amount, :category
  validates_numericality_of :amount, only_integer: true, if: :amount
end
