class Event < ActiveRecord::Base
  serialize :responses, Hash
  serialize :invited, Array 

  def all_active
    Event.all.where(status: 'active')
  end 

end
