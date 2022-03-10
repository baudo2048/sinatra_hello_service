require 'sinatra/base'
require "faraday"
require "json"
require 'active_record'
require 'sinatra/activerecord'

class MainApp < Sinatra::Base
  get '/' do
    puts "--> #{@result}"
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["MAINAPP_URL"]
    url = "#{servicehost}/api/sync"
    data = Faraday.get(
      url,
      params: {param: '1'},
      headers: {'Content-Type' => 'application/json'}
    ).body
    @result = JSON.parse(data, symbolize_names: true)
    puts @result
    redirect '/'
  end
end
