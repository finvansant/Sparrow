
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
    @event = Event.find(session["event"])
    if !@event
      event_host
    elsif @event.active && session["counter"] == 1
      event_reply
    end
  end

  def event_host  
    # Grab the phone number from incoming Twilio params
    @from_number  = params[:From]
    @user = User.find_by(phone: @from_number)
    @body         = params[:Body]
    message_array = @body.split
    @group = @user.groups.find_by(name: message_array[0])
    if @group
        message_body = message_array[1..-1].join(' ')
        @event = Event.create(host_id: @user.id, body: message_body, yes_tot: 0, no_tot: 0, active: true)
        
        client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        from = ENV['TEXTIGO_PHONE'] # Your Twilio number
        
        @event.guests = @group.friends
        @event.guests.each do |guest|
          client.account.messages.create(
            :from => from,
            :to => guest.phone,
            :body => "hey #{guest.name}, #{@event.body}"
            )
          session["event"] == @event.id
          session["counter"] == 1
        end
        redirect_to root_url

    end
  end

  def event_reply
    @event = Event.find(session["event"])
    @from_number  = params[:From]
    @guest = @event.guests.find_by(phone: @from_number)
    @guest.event_guest.reply = params[:Body]
    @event.check_replies
    if @event yes_tot > 0
      @event.guests.each do |guest|
        respond("Thanks everyone, got it covered!")
        session["event"] = nil
        session["counter"] = nil
        @event.active = false
      end
    end
  end

  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
  end

end
