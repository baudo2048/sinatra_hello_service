require 'sinatra/base'
require "faraday"
require "json"

class MainApp < Sinatra::Base
  get '/' do
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["MAINAPP_URL"]
    url = "#{servicehost}/api/sync"
    puts url
    data = Faraday.get(url,
                       params: {param: '1'},
                       headers: {'Content-Type' => 'application/json'}
                      ).body
    puts data.to_s
    result = JSON.parse(data, symbolize_names: true)
    puts "Service Called #{result}"
  end
end
