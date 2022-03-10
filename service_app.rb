require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  get "/api/sync/?" do
    content_type :json
    sleep 3
    {message: "Sync api called: #{Time.now}"}.to_json
  end
end
