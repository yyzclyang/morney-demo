class Record < ApplicationRecord
  validates_presence_of :amount, :category
  validates_numericality_of :amount, only_integer: true, if: :amount
end
