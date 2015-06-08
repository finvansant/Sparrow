class Friend < ActiveRecord::Base

  before_save :normalize_phone

  belongs_to :user
    has_many :group_friends
  has_many :groups, through: :group_friends
  has_many :invitations
  has_many :events, through: :invitations

  def normalize_phone
    # get phone number
    @phone = self.phone
    result = @phone.gsub(/[^\d]/, '')
    if result.length == 10
      result = "+1" + result
    elsif result.length == 11 && result[0] == "1"
      result = "+" + result
    end
    self.phone = result
    # check if all characters are digits
    # remove all non-digit characters
    # check that length is 10
    # if 10 characters, prepend "+1"
  end

end
