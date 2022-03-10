require 'sinatra/base'

class ServiceApp < Sinatra::Base
  get "/api/synch" do
    puts "Sync Random Called!"
  end
end