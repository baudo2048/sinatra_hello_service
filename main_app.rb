require 'sinatra/base'
require "faraday"
require "json"
<<<<<<< HEAD
require 'active_record'
require 'sinatra/activerecord'
=======
>>>>>>> 17455b9146f874654b3b22ba4fe8b022e81cb000

class MainApp < Sinatra::Base
  get '/' do
    erb :home_page
  end

  post '/sync/random/' do
    servicehost = ENV["MAINAPP_URL"]
    url = "#{servicehost}/api/sync"
<<<<<<< HEAD
=======
    puts url
>>>>>>> 17455b9146f874654b3b22ba4fe8b022e81cb000
    data = Faraday.get(
      url,
      params: {param: '1'},
      headers: {'Content-Type' => 'application/json'}
    ).body
<<<<<<< HEAD
    result = JSON.parse(data, symbolize_names: true)
=======
    puts data.to_s
    result = JSON.parse(data, symbolize_names: true)
    puts "Service Called #{result}"
>>>>>>> 17455b9146f874654b3b22ba4fe8b022e81cb000
  end
end
