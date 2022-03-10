require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  self.counter = 0

  get "/api/sync/?" do
    content_type :json
    self.counter += 1
    { message: "Sync called #{self.counter}"}.to_json
  end
end
