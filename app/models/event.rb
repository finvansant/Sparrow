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


  # def self.find_matching_invitation(friend_ids)
  #   all_active_events = self.all_active
  #   friends = friend_ids.map {|friend_id| Friend.find(friend_id)}
  #   friends.map { |friend|  all_active_events.find_by(host: friend.user_id) }.uniq.first
  # end

  def self.invitation_friend_id(friend_ids) 
    all_active_events = self.all_active
    friends = friend_ids.map {|friend_id| Friend.find(friend_id)}
    friend = friends.select { |friend|  all_active_events.find_by(host: friend.user_id) }.uniq.first
    friend.id
  end 

  def close_event?
    if self.yes_total >= self.total_invited
      self.status = 'inactive'
      return true
    else
      return false
    end
  end

  def attendee_names
    attendee_ids = []
    self.invitations.each {|i| attendee_ids << i.friend_id if i.reply == 'yes'}
    attendee_ids.map {|id| Friend.find(id).name }
  end

end
