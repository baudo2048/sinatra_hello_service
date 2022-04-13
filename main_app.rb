require "sucker_punch"
require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'
require 'faker'
require_relative 'models/user'
require_relative 'models/follow'
require_relative 'models/tweet'
require_relative 'lib/bulk_data'
require_relative 'lib/sucker_run'
require_relative 'lib/work_queue'
require "logger"

class MainApp < Sinatra::Base
  enable :sessions
  configure do
    set(:logger) { Logger.new($stdout) }
    set(:queue) { WorkQueue.new(ENV['CLOUDAMQP_URL']) }
  end

  before do
    @logger = Logger.new($stdout)
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    @conn = Faraday.new(url)
  end

  get '/' do
    @users = User.all
    @tweets = Tweet.all
    @follows = Follow.all
    erb :home_page
  end

  post '/users/add/sync' do
    response = @conn.get("/api/user/add/sync/") do |req|
      req.params = {user_count: 250}
      req.headers = {'Content-Type' => 'application/json'}
    end
    session[:result] = JSON.parse(response.body, symbolize_names: true)
    redirect to('/')
  end

  post '/users/add/async' do
    response = @conn.get("/api/user/add/async/") do |req|
      req.params = {user_count: 250}
      req.headers = {'Content-Type' => 'application/json'}
    end
    @logger.info "asynch response body: #{response.body}"
    session[:result] = JSON.parse(response.body, symbolize_names: true)
    redirect to('/')
  end

  post '/seed/addusers/sync' do
    BulkData.new.load_all_seed_users
    redirect to('/')
  end
  post '/seed/addfollows/sync' do
    BulkData.new.load_all_follows
    redirect to('/')
  end

  post '/seed/addtweets/sync' do
    BulkData.new.load_seed_tweets_firsttry
    redirect to('/')
  end

  post '/seed/addtweetsfast/sync' do
    @logger.info("Adding Seed Tweets Sync")
    BulkData.new.load_seed_tweets_faster
    redirect to('/')
  end

  post '/seed/deleteall/sync' do
    BulkData.new.delete_all_tweets
    BulkData.new.delete_all_follows
    BulkData.new.delete_all_users
    redirect to('/')
  end

  post '/seed/addtweets/sucker' do
    SuckerRun.perform_async
    redirect to('/')
  end

  post '/users/add/queue' do
    settings.queue.publish_user_create_message(create_random_users_json(20))
    redirect to('/')
  end

  post '/queue/users/validate' do
    user = User.limit(1).order("random()")
    if user.size > 0
      user_to_validate = user.first.id.to_json
      settings.queue.publish_user_validate_message(user_to_validate)
    redirect to('/')
  end

  def create_random_users_json(count)
    result = []
    count.times { result << {name: Faker::Name.name, email: Faker::Internet.email} }
    result.to_json
  end
end
