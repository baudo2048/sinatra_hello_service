require "bunny"
require_relative '../models/user'
require_relative '../lib/validate'
class WorkQueue
  def initialize url
    @logger = Logger.new($stdout)
    @logger.info "Create and start queue"
    @bunny = Bunny.new(url, {tls_silence_warnings: true})
    @channel = @bunny.create_channel
    @ucqueue = @channel.queue("user_create")
    @valqueue = @channel.queue("user_validate")
    @bunny.start
  end

  def ucmessage_count
    @ucqueue.message_count
  end

  def valmessage_count
    @valqueue.message_count
  end

  def publish_user_create_message(users_as_json)
    @channel.default_exchange.publish(users_as_json, routing_key: @ucqueue.name)
  end

  def publish_user_validate_message(user_ident_json)
    @channel.default_exchange.publish(user_ident_json, routing_key: @valqueue.name)
  end

  def user_create_start_background
    Thread.new do
      loop do
        @ucqueue.subscribe(block: true) do |_delivery_info, _properties, body|
          User.insert_all JSON.parse(body)
        end
      end
    end
  end

  def user_validate_start_background
    Thread.new do
      loop do
        @bunny.start
        @valqueue.subscribe(block: true) do |_delivery_info, _properties, body|
          Validate.new.validate_user JSON.parse(body)
        end
      end
    end
  end
end
