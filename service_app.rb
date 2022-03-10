require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base

  enable :sessions

  get "/api/sync/?" do
    content_type :json
    session[:count] = 0 if session[:count].nil?
    { message: "Sync called #{session[:count]}"}.to_json
    session[:count] += 1
  end
end
