class Tag < ApplicationRecord
  validates_presence_of :name
  validates_length_of :name, maximum: 20, if: :name
end
