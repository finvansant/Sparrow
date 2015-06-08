class Event < ActiveRecord::Base
  # serialize :responses, Hash
  # serialize :invited, Array 
  has_many :invitations
  has_many :friends, through: :invitations

  def all_active
    Event.all.where(status: 'active')
  end 

  # def invited 
  #   invited_array = []
  #   self.invited.each {|e| invited_array << e}
  #   invited_array
  # end 

end
