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
    set :logger, Logger.new($stdout)
    settings.logger.info("mainapp configure worked class #{ENV}")
    workqueue = WorkQueue.new(ENV['CLOUDAMQP_URL'])
    set :queue, workqueue
  end

  before do
    @logger = Logger.new($stdout)
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    @conn = Faraday.new(url)
    settings.logger.info("mainapp before block #{ENV}")
    settings.logger.info("mainapp before block #{ENV["SERVAPP_URL"]}")
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
    @logger.info("addtweets/sync")
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
    @logger.info("Adding users using aueue")
    settings.queue.publish_user_create_message(create_random_users_json(10))
    redirect to('/')
  end

  def create_random_users_json(count)
    result = []
    count.times { result << {name: Faker::Name.name, email: Faker::Internet.email} }
    result.to_json
  end
end
