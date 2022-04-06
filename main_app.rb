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
    erb :home_page
  end

  post '/users/add/sync' do
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    @logger.info "---> #{url}"
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
<<<<<<< Updated upstream
=======

  post '/seed/add/sync' do
  end
>>>>>>> Stashed changes
end
