class Group < ActiveRecord::Base
  belongs_to :user
  has_many :group_friends
  has_many :friends, through: :group_friends

  validate :valid_name

  private

  def valid_name
    if self.name =~ /\A[a-zA-Z0-9]+\z/
    else
      self.errors[:name] = "only allows one word, containing letters and/or numbers"
    end
  end

end
