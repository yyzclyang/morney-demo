class Tag < ApplicationRecord
  validates_presence_of :name
  validates_length_of :name, maximum: 30, if: :name
end
