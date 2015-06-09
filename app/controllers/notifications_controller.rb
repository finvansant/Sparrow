
class NotificationsController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token

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
    # Need to add Event.create here (also need to add a form field for event create)
    # Event.create(name: @message_body, host: @user.id, guests: {}, status: 'active')

    redirect_to root_url
  end

 # Receive incoming SMS
  def incoming
    # Grab the phone number from incoming Twilio params
    @phone_number = params[:From]
    # set session counter to zero if it doesn't exist.  
    session["counter"] ||= 0
    sms_count = session["counter"]
    sms_type = session['person_type']
    
    @body = params[:Body].downcase
    message_array = @body.split

    # Is this user in our database
    if User.exists?(phone: @phone_number)
      #there is a user 
      #if there is a group that matches message[0], iterate and send invite 
      # set the session status to host. ie, we have a user and a group
      @user = User.find_by(phone: @phone_number)
      @group = @user.groups.find_by(name: message_array[0])
      if @group



        session['person_type'] = 'host'
        @message_body = message_array[1..-1].join(' ')
        @select_friends = @group.friends
    
        output = "Message sent to '#{message_array[0]}' group."
        event = Event.create(name: @message_body, host: @user.id, status: 'active')
        @select_friends.each { |friend| Invitation.create(friend_id: friend.id, event_id: event.id)}

        send_group(@message_body, @select_friends)
      else 
        output = "#{message_array[0]} is not a group. please make one"
      end 
    else
       
      # user's phone doesn't exist in our DB (this will have to change)
      # user's phone is matches to an event that has a status of active
      # if Event.all_active includes our current number...  
# binding.pry
      if Event.all.include?(@phone_number)
          session['person_type'] = 'guest'
          output = process_guest(@body, @phone_number, sms_count)
      else
          output = "Hmm... Try creating a new event @ Textigo.com. No active invites or groups associated with this number."
      end 
    end

    # Render the TwiML response
    respond(output)
    session["counter"] += 1

  end

  # Helper method for sending an SMS response (to person who called)
  
  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
  end

  def send_group(msg, select_friends)
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    from = ENV['TEXTIGO_PHONE'] # Your Twilio number
        select_friends.each do |friend|
        @client.account.messages.create(
                    :from => from,
                    :to => friend.phone,
                    :body => "hey #{friend.name}, #{msg}, [In] or [Out]?"
                    )
        end
  end

  private

    # This is a helper method for processing incoming SMS. We can 
    # put our message logic in here for now 
    def process_guest(message, phone, sms_count)

      in_array = ['in', 'i', 'y', 'yes']
      out_array = ['out', 'o', 'n', 'no']

      message_array = @body.split

      name = get_name(phone)

      if in_array.includes?(message_array[0])
          # change it in the Event model? 
          output = "Glad you can make it, #{name}. See you there."

          # todo: update the response array in Event and yes_total += 1
        
        elsif out_array.includes?(message_array[0])
          output = "Sorry to miss you #{name}. Maybe next time."
          # todo: update the response array in Event and no_total += 1
          # (later, trigger the cascade)   

        else
          output =  "Sorry, I didn't understand your response, please just type [In] or [Out]. Thanks! (end of proc_guest)"
        end
      return output
    end



    def process_message(message, sms_count, sms_type)

      if message == 'in'
        output = "great. we will see you there. #{sms_type}sms: #{sms_count}"
      elsif message == 'out'
        output = "sorry to hear. #{sms_type}sms: #{sms_count}"
      elsif message == 'zero'
        session['counter'] = 0
        sms_count = session['counter'] 
        session['person_type'] = "host"
        sms_type = session['person_type']

        output = "#{sms_type} got it #{sms_count}"
      end
      return output
    end

    def get_name(phone_number)
      friend = Friend.find(phone: phone_number)
      friend.name
    end


end
