require 'sinatra/base'

class ServiceApp < Sinatra::Base
  get "/api/random" do
    puts "Random Called!"
  end
end