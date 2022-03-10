require 'sinatra/base'
require "faraday"
require "json"

class MainApp < Sinatra::Base
  get '/' do
    erb :home_page
  end

  post '/sync/random/' do
    service_url = ENV["MAINAPP"]
    url = "#{service_url}/api/sync"
    data = Faraday.get(url).body
    result = JSON.parse(data, symbolize_names: true)
    puts "Service Called!"
  end
end
