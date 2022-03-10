require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'

class MainApp < Sinatra::Base

  enable :sessions

  get '/' do
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["SERVAPP_URL"]
    url = "#{servicehost}/api/sync"
    puts "---> #{url}"
    data = Faraday.get(
      url,
      headers: {'Content-Type' => 'application/json'}
    ).body
    session[:result] = JSON.parse(data, symbolize_names: true)
    redirect to('/')
  end
end
