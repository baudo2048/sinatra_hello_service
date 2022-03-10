require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  get "/api/sync/?" do
    content_type :json
    sleep 3
    {message: "Sync api called"}.to_json
  end
end
