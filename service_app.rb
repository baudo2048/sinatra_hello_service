require 'sinatra/base'
require 'json'
require 'logger'
require 'faker'
require 'active_record'
require 'sinatra/activerecord'
require 'pusher'
require_relative 'models/user'

class ServiceApp < Sinatra::Base
  before do
    @logger = Logger.new($stdout)
    @logger.info "Hello Paper Trail: this is servapp"
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
    @logger.info "Sync equesting: #{params[:user_count]}"
    create_random_user(params[:user_count].to_i)
    {message: "#{Time.now}"}.to_json
  end

  get "/api/user/add/async/?" do
    content_type :json
    @logger.info "Sync equesting: #{params[:user_count]}"
    Thread.new do
      final_total = create_random_user(params[:user_count].to_i)
      @logger.info "Asynch processing done. Triggering push"
      @pusher.trigger('my-channel', 'my-event', {
                        message: "#{Time.now}",
                        final_total: "#{final_total}"
                      })
    end
    {message: " #{Time.now}"}.to_json
  end

  def create_random_user(count)
    count.times { User.create(name: Faker::Name.name, email: Faker::Internet.email) }
    User.all.count
  end
end
