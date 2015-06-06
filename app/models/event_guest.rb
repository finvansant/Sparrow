class EventGuest < ActiveRecord::Base
  belongs_to :event
  belongs_to :guest, :class_name => 'Friend', :foreign_key => 'friend_id'
  
  def format_replies
    if self.reply == 'yes' || 'yep' || '1' || 'y' || 'totally'
      self.reply = 'y'
    elsif self.reply == 'no' || 'nope' || '1' || 'n' || 'can\'t'
      self.reply = 'n'
    end
  end
end
