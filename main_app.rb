require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/follow'
require_relative 'models/tweet'
require_relative 'lib/bulk_data'
require "logger"

class MainApp < Sinatra::Base
  enable :sessions

  before do
    @logger = Logger.new($stdout)
  end

  get '/' do
    @logger.info "Hello Paper Trail: this is mainapp"
    @users = User.all
    @tweets = Tweet.all
    @follows = Follow.all
    @logger.info("session result |#{session[:result]}|")
    erb :home_page
  end

  post '/users/add/sync' do
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    conn = Faraday.new(url)
    response = conn.get("/api/user/add/sync/") do |req|
      req.params = {user_count: 250}
      req.headers = {'Content-Type' => 'application/json'}
    end
    session[:result] = JSON.parse(response.body, symbolize_names: true)
    redirect to('/')
  end

  post '/users/add/async' do
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    @logger.info "---> #{url}"
    conn = Faraday.new(url)
    response = conn.get("/api/user/add/async/") do |req|
      req.params = {user_count: 250}
      req.headers = {'Content-Type' => 'application/json'}
    end
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
    @logger.info("Adding Seed Tweets Sync")
    BulkData.new.load_seed_tweets_firsttry
    redirect to('/')
  end

  post '/seed/addtweets/sync' do
    @logger.info("Adding Seed Tweets Sync")
    BulkData.new.load_seed_tweets_firsttry
    redirect to('/')
  end

  post '/seed/deleteall/sync' do
    BulkData.new.delete_all_tweets
    BulkData.new.delete_all_follows
    BulkData.new.delete_all_users
    redirect to('/')
  end
end
