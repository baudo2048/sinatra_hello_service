require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'
require_relative 'models/user'
require "logger"

class MainApp < Sinatra::Base
  enable :sessions

  before do
    @logger = Logger.new(STDOUT)
  end

  get '/' do
    @logger.info "Hello Paper Trail: this is mainapp"
    @users = User.all
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com"
    @logger.info "---> #{url}"
    conn = Faraday.new(url)
    response = conn.get("/api/sync") do |req|
      req.params = { user_count: 5}
      req.headers = {'Content-Type' => 'application/json'}
    end
    session[:result] = JSON.parse(response.body, symbolize_names: true)
    redirect to('/')
  end
end
