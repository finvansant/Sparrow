class Friend < ActiveRecord::Base
  belongs_to :user
    has_many :group_friends
  has_many :groups, through: :group_friends
end
