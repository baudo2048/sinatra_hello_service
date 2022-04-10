require "bunny"
class WorkQueue
  def initialize
    @conn = Bunny.new
  end

  def open_channel
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue("user_create")
  end

  def publish_user_create_message(_users_as_json)
    @channel.default_exchange.publish(users_as_array, routing_key: @queue.name)
  end

  def close_channel
    @conn.close
  end
end
