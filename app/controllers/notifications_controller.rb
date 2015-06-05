
class NotificationsController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token
  @@all_responses = []

  def index
  end

  def notify
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = client.messages.create from: ENV['TEXTIGO_PHONE'], to: ENV['CHAD_PHONE'], body: 'Learning to send SMS you are.', status_callback: 'https://ba74edc7.ngrok.io/twilio/status'

    render plain: message.status

  end

  def desktop_send
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

        from = ENV['TEXTIGO_PHONE'] # Your Twilio number
        select_friends = Group.find(params[:id]).friends
        select_friends.each do |friend|
          client.account.messages.create(
            :from => from,
            :to => friend.phone,
            :body => "Hey #{friend.name}, Hackattack at 6PM. Bring Computer!"
          )
        end
    redirect_to root_url
  end

# you can send a text to a group, by iterating over a hash

  def incoming
    # Grab the phone number from incoming Twilio params
    @from_number  = params[:From]

    @user = User.find_by(phone: @from_number)

    # Find the subscriber associated with this number or create a new one
    # @new_subscriber = Subscriber.exists?(:phone_number => @phone_number) === false
    # @subscriber = Subscriber.first_or_create(:phone_number => @phone_number)

    @body         = params[:Body]
    message_array = @body.split
    @group = @user.groups.find_by(name: message_array[0])
    if @group

        message_body = message_array[1..-1].join(' ')

        client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

        from = ENV['TEXTIGO_PHONE'] # Your Twilio number
        select_friends = @group.friends
        select_friends.each do |friend|
        client.account.messages.create(
                    :from => from,
                    :to => friend.phone,
                    :body => "hey #{friend.name}, #{message_body}"
                    )
        end
        redirect_to root_url

    end

    # output = @body
    # @@all_responses << @body
    # @@all_responses << @from_number
    # @@all_responses << @number_name

    # @responses = @@all_responses
    # Render the TwiML response
    # respond(output)

    # render 'index'
  end

  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
  end

end
