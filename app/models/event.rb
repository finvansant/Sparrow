class Event < ActiveRecord::Base
  belongs_to :host, :class_name => 'User', :foreign_key => 'user_id'
  has_many :event_guests
  has_many :guests, through: :event_guests
end
