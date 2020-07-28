class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(payload)
    Message.create!(user_id: User.first.id, room_id: payload['message']['room_id'], content: payload['message']['message'])
  end
end
