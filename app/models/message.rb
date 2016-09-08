class Message < ApplicationRecord
  belongs_to :guest, touch: true
  belongs_to :room, touch: true
end
