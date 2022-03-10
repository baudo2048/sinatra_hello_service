require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  before do
    content_type :json
  end

  get "/api/synch" do
    puts "yes!"
    { message: "Sync Random Called!"}.to_json
  end
end
