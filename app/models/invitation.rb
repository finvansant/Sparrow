class Invitation < ActiveRecord::Base
  belongs_to :friend
  belongs_to :event

  # currently not in use
  def is_invited?(number)
    self.friend_id == Friend.get_id_from_number(number)
  end

  # find invitations for all active events
  def self.all_active
    self.select do |invite|
      invite.event.status == 'active'
    end
  end

  # find match between friend and invitation
  def self.find_matching_invitation(friend_ids)
    all_active_invites = self.all_active
    # iterate through all friend IDs corresponding to a phone number
    my_active = friend_ids.map do |friend_id|
      # find all invitations associated with each friend ID
      all_active_invites.select do |invite|
        invite.friend_id == friend_id
      end
    end
  end

end
