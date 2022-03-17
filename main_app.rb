require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'
require_relative 'models/user'

class MainApp < Sinatra::Base
  enable :sessions
  
  before do
    @logger = RemoteSyslogLogger.new('syslog.domain.com', 514,
                  :program => "main_app",
                  :local_hostname => "optional_hostname")
  end

  get '/' do
    @logger.info "Hello Paper Trail"
    @users = User.all
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["SERVAPP_URL"]
    url = "https://#{servicehost}.herokuapp.com/api/sync"
    @logger.info "---> #{url}"
    data = Faraday.get(
      url,
      headers: {'Content-Type' => 'application/json'}
    ).body
    session[:result] = JSON.parse(data, symbolize_names: true)
    redirect to('/')
  end
end
