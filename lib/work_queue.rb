require "bunny"
require_relative 'models/user'
class WorkQueue
  def initialize url
    @logger = Logger.new($stdout)
    @logger.info("WorkQueue: constructing for |#{url}|")
    @conn = Bunny.new url
    @logger.info("@conn = #{@conn}")
    @conn.start
    @channel = @conn.create_channel
    @logger.info("@channel = #{@channel}")
    @queue = @channel.queue("user_create")
    @logger.info("@queue = #{@queue}")
  end

  def message_count
    @queue.message_count
  end

  def publish_user_create_message(users_as_json)
    @logger.info("publish_user_create_message: #{users_as_json}")
    @channel.default_exchange.publish(users_as_json, routing_key: @queue.name)
  end

  def start_background
    @logger.info("WorkQueue: Starting background worker")
    Thread.new do
      @logger.info("WorkQueue running")
      loop do
        @queue.subscribe(block: true) do |_delivery_info, _properties, body|
          @logger.info("WorkQueue received message")
          User.add_all JSON.parse(body)
        end
      end
    end
  end
end
