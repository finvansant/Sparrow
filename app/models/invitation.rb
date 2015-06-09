class Invitation < ActiveRecord::Base
  belongs_to :friend
  belongs_to :event

  def is_invited?(number)
    self.friend_id == Friend.get_id_from_number(number)
  end 

  def self.all_active
    self.select do |invite|
      invite.event.status == 'active'
    end
  end 

  def self.find_matching_invitation(friend_ids)
    all_active_invites = self.all_active
    my_active = friend_ids.map do |friend_id|  
          all_active_invites.select do |invite|
            invite.friend_id == friend_id
          end 
    end
  end

  
end
