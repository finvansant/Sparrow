class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups
  has_many :friends

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
