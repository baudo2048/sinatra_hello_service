require "bunny"
require_relative '../models/user'
class WorkQueue
  def initialize url
    @bunny = Bunny.new url
    @bunny.start
    @channel = @bunny.create_channel
    @queue = @bunny.queue("user_create")
  end

  def message_count
    @bunny.start
    @queue.message_count
    @bunny.stop
  end

  def publish_user_create_message(users_as_json)
    @bunny.start
    @channel.default_exchange.publish(users_as_json, routing_key: @queue.name)
    @bunny.stop
  end

  def start_background
    Thread.new do
      loop do
        @bunny.start
        @queue.subscribe(block: true) do |_delivery_info, _properties, body|
          User.insert_all JSON.parse(body)
        end
        @bunny.stop
      end
    end
  end
end
