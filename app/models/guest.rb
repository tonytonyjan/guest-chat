class Guest < ApplicationRecord
  has_many :messages, dependent: :destroy
end
