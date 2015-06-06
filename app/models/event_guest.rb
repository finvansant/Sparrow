class EventGuest < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest, :class_name => 'Friend', :foreign_key => 'friend_id'
end
