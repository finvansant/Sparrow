class Invitation < ActiveRecord::Base
  belongs_to :friend
  belongs_to :event

  def is_invited?(number)
    self.friend_id == Friend.get_id_from_number(number)
  end 

end
