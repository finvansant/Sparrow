class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :normalize_phone

  has_many :groups
  has_many :friends

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




  # currently not in use
  def send_message(msg)
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :body => msg,
    )
    puts message.to
  end

  # currently not in use
  def send_group(msg, select_friends)
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    from = ENV['TEXTIGO_PHONE'] # Your Twilio number
        select_friends.each do |friend|
        @client.account.messages.create(
                    :from => @twilio_number,
                    :to => friend.phone,
                    :body => "hey #{friend.name}, #{message_body}, [In] or [Out]?"
                    )
        end
    puts message.to
  end
end
