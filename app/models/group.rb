class Group < ActiveRecord::Base
  belongs_to :user
  has_many :group_friends
  has_many :friends, through: :group_friends
  before_validation :downcase_name
  validate :valid_name
  validates :name, uniqueness: {scope: :user_id, message: "This group name already exists!"}

  private

  def valid_name
    if self.name =~ /\A[a-z0-9]+\z/
    else
      self.errors[:name] = "only allows one word, containing letters and/or numbers"
    end
  end

  def downcase_name
    self.name.downcase!
  end

end
