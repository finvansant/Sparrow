class UserController < ApplicationController

  def index

  end

  def show
    @user = User.find(params[:id])
    @groups = @user.groups
    @friends = @user.friends
  end

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


end
