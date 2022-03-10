require 'sinatra/base'
require "faraday"
require "json"

class MainApp < Sinatra::Base
  get '/' do
    erb :home_page
  end

  get '/sync/random/' do
    url = "http://dummy.restapiexample.com/api/v1/employees"
    data = Faraday.get(url).body
    result = JSON.parse(data, symbolize_names: true)
    assert_equal :success, result[:status]
  end
end
