require "bunny"
class WorkQueue
  def initialize
    @logger.info("Constructing WorkQueue")
    @conn = Bunny.new ENV['CLOUDAMQP_URL']
  end

  def open_channel
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue("user_create")
  end

  def publish_user_create_message(users_as_json)
    @channel.default_exchange.publish(users_as_json, routing_key: @queue.name)
  end

  def close_channel
    @conn.close
  end
end
