class Message < ActiveRecord::Base
  default_scope { order('id ASC') }
  belongs_to :guest, touch: true
  belongs_to :room, touch: true
end
