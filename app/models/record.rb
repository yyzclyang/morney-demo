class Record < ApplicationRecord
  enum category: {outgoings: 1, income: 2}

  validates_presence_of :amount, :category
  validates_numericality_of :amount, only_integer: true, if: :amount
end
