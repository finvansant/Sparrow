class Event < ActiveRecord::Base
  # serialize :responses, Hash
  # serialize :invited, Array 
  has_many :invitations
  has_many :friends, through: :invitations

  def self.all_active
    Event.all.where(status: 'active')
  end 


  def increment_yes_total
    total = self.yes_total
    total += 1 
    self.yes_total = total 
    self.save
  end

  def increment_no_total
    total = self.no_total
    total += 1 
    self.no_total = total
    self.save
  end

  def self.last_active_invite(friend_id)
    active_events = self.all_active
    active_invites = active_events.select { |e| e.invitations.where(friend_id: friend_id) }
    
    active_invites.last
  end
end
