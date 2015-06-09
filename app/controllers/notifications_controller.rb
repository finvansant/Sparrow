
class NotificationsController < ApplicationController
  include Webhookable
  skip_before_action :verify_authenticity_token

  def index
  end


  def desktop_send
    client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

        from = ENV['TEXTIGO_PHONE']
        select_friends = Group.find(params[:id]).friends
        select_friends.each do |friend|
          client.account.messages.create(
            :from => from,
            :to => friend.phone,
            :body => "Hey #{friend.name}, Hackattack at 6PM. Bring Computer!" # add form logic for this text body
          )
    end
    # Need to add Event.create here (also need to add a form field for event create)
    # Event.create(name: @message_body, host: @user.id, guests: {}, status: 'active')

    redirect_to root_url
  end


  def incoming
    @phone_number = params[:From] 
    @body = params[:Body].downcase
    message_array = @body.split

    if Friend.exists?(phone: @phone_number)  
      friend_ids = Friend.get_all_ids_from_number(@phone_number)
      @active_invite = Event.find_matching_invitation(friend_ids)
      @event_id = @active_invite.id

      if @active_invite
          session['person_type'] = 'guest'
          output = process_guest(@body, @phone_number, @event_id)
      end
   
    elsif User.exists?(phone: @phone_number)
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
      output = "Hmm... Try creating a new event @ Textigo.com. No active invites or groups associated with this number." 
    end

    respond(output)
    session["counter"] += 1

  end

  
  def respond(message)
      response = Twilio::TwiML::Response.new do |r|
        r.Message message
      end
      render text: response.text
  end

  def send_group(msg, select_friends)
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    from = ENV['TEXTIGO_PHONE']
        select_friends.each do |friend|
        @client.account.messages.create(
                    :from => from,
                    :to => friend.phone,
                    :body => "hey #{friend.name}, #{msg}, [In] or [Out]?"
                    )
        end
  end

  private

    def process_guest(message, phone, event_id)

      in_array = ['in', 'i', 'y', 'yes']
      out_array = ['out', 'o', 'n', 'no']

      message_array = @body.split

      name = get_name(phone)

      if in_array.include?(message_array[0])
          # change it in the Event model? 
          output = "Glad you can make it, #{name}. See you there."
          active_event = Event.find(@event_id)
          active_event.increment_yes_total
          host_message = "New RSVP from #{name}. Yes: #{active_event.yes_total} No: #{active_event.no_total}"
          send_host(host_message, active_event.host)
          if active_event.close_event?
            host_message = "Invitation filled. Total attending: "
            send_host(host_message, active_event.host)
          end

        elsif out_array.include?(message_array[0])
          output = "Sorry to miss you #{name}. Maybe next time."
          active_event = Event.find(@event_id)
          active_event.increment_no_total
          host_message = "New RSVP from #{name}. Yes: #{active_event.yes_total} No: #{active_event.no_total}"
          send_host(host_message, active_event.host)

        else
          output =  "Sorry, I didn't understand your response, please just type [In] or [Out]. Thanks! (end of proc_guest)"
        end
      return output
    end


    def get_name(phone_number)
      friend = Friend.find_by(phone: phone_number)
      friend.name
    end

    def send_host(output, host_id)

      host = User.find(host_id)

        @twilio_number = ENV['TEXTIGO_PHONE']
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        message = @client.account.messages.create(
          :from => @twilio_number,
          :to => host.phone,
          :body => output,
        )
      
    end 

end
