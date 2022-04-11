require "bunny"
class WorkQueue
  def initialize
    @logger = Logger.new($stdout)
    @logger.info("Constructing WorkQueue")
    @conn = Bunny.new ENV['CLOUDAMQP_URL']
  end

  def open_channel
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

  def close_channel
    @conn.close
  end

  def run_background
    Thread.new do
      open_channel
      @logger.info("WorkQueue running")
      loop do
        @logger.info("WorkQueue looping")
        @queue.subscribe(block: true) do |delivery_info, properties, body|
          @logger.info("WorkQueue received message")
          @logger.info("WorkQueue message body: #{body}")
          @logger.info("WorkQueue message properties: #{properties}")
          @logger.info("WorkQueue message delivery_info: #{delivery_info}")
        end
      end
    end
  end
end
