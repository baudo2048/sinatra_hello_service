require 'sinatra/base'
require 'json'
require 'remote_syslog_logger'


class ServiceApp < Sinatra::Base
  get "/api/sync/?" do
    content_type :json
    sleep 3
    {message: "Sync api called: #{Time.now}"}.to_json
  end
end
