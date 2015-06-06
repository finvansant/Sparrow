class Event < ActiveRecord::Base
  belongs_to :host, :class_name => 'User', :foreign_key => 'user_id'
  has_many :event_guests
  has_many :guests, through: :event_guests

  def check_replies
    self.event_guests.each do |guest|
    if guest.reply == 'y'
      self.yes_tot += 1
    elsif guest.reply == 'n'
      self.no_tot += 1
    end   
  end
end
