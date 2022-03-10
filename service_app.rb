require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  before do
    puts "before"
  end

  get "/api/sync/?" do
    content_type :json
    puts "yes!"
    { message: "Sync Random Called!"}.to_json
  end
end
