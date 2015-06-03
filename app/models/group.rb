class Group < ActiveRecord::Base
  belongs_to :user
  has_many :group_friends
  has_many :friends, through: :group_friends
end
