require "sucker_punch"
require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/follow'
require_relative 'models/tweet'
require_relative 'lib/bulk_data'
require_relative 'lib/sucker_run'
require "logger"

class MainApp < Sinatra::Base
  enable :sessions

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
    SuckerRun.perform_async
    redirect to('/')
  end
end
