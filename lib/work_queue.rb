require "bunny"
require_relative '../models/user'
class WorkQueue
  def initialize url
    @conn = Bunny.new url
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue("user_create")
  end

  def message_count
    @queue.message_count
  end

  def publish_user_create_message(users_as_json)
    @channel.default_exchange.publish(users_as_json, routing_key: @queue.name)
  end

  def start_background
    Thread.new do
      loop do
        @queue.subscribe(block: true) do |_delivery_info, _properties, body|
          User.insert_all JSON.parse(body)
        end
      end
    end
  end
end
