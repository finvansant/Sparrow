class Friend < ActiveRecord::Base

  before_save :normalize_phone

  belongs_to :user
  has_many :group_friends
  has_many :groups, through: :group_friends
  has_many :invitations
  has_many :events, through: :invitations
  validates :phone, presence: true

  # formats phone entry to E.123
  def normalize_phone
    # get phone number
    @phone = self.phone
    # deletes all brackets and parentheses in phone number string
    result = @phone.gsub(/[^\d]/, '')
    # checking if phone number needs '+' or '+1' prepended to it
    if result.length == 10
      result = "+1" + result
    elsif result.length == 11 && result[0] == "1"
      result = "+" + result
    end
    self.phone = result
  end

  def self.get_id_from_number(number)
    friend = self.find_by(phone: number)
    friend.id
  end

  # get all friend IDs corresponding to phone number from all groups
  def self.get_all_ids_from_number(number)
    friends = self.all.select { |friend| friend.phone == number }
    friends.map { |friend| friend.id }
  end

end
