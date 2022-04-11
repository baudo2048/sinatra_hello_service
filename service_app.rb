require "sucker_punch"
require 'sinatra/base'
require 'json'
require 'logger'
require 'faker'
require 'active_record'
require 'sinatra/activerecord'
require "sinatra/json"
require 'pusher'
require_relative 'models/user'
require_relative 'models/follow'
require_relative 'models/tweet'
require_relative 'lib/bulk_data'
require_relative 'lib/work_queue'

class ServiceApp < Sinatra::Base
  configure do
    set :logger, Logger.new($stdout)
    settings.logger.info "servapp configure worked #{ENV}"
    set :queue, WorkQueue.new(ENV['CLOUDAMQP_ONYX_URL'])
    settings.queue.start_background
  end

  before do
    @logger = Logger.new($stdout)
    settings.logger.info "before block logger worked"

    @pusher = Pusher::Client.new(
      app_id: '1363367',
      key: 'dd9f23cab2c8652cbd08',
      secret: 'ebea9a2c32552c6fb48b',
      cluster: 'us2',
      encrypted: true
    )
  end

  get "/api/user/add/sync/?" do
    content_type :json
    create_random_user(params[:user_count].to_i)
    json({message: Time.now})
  end

  get "/api/user/add/async/?" do
    content_type :json
    Thread.new do
      create_random_user(params[:user_count].to_i)
      @logger.info "Asynch processing done. Triggering push"
      @pusher.trigger('my-channel', 'my-event', {
                        message: Time.now.to_s,
                        user_total: User.all.count.to_s,
                        tweet_total: Tweet.all.count.to_s,
                        follow_total: Follow.all.count.to_s
                      })
    end
    json({message: Time.now})
  end

  def create_random_user(count)
    count.times { User.create(name: Faker::Name.name, email: Faker::Internet.email) }
    User.all.count
  end
end
