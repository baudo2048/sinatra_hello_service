require 'sinatra/base'
require 'json'
require 'logger'

class ServiceApp < Sinatra::Base

  before do
    @logger = Logger.new(STDOUT)
  end


  get "/api/sync/?" do
    @logger.info "Hello Paper Trail: this is servapp"
    content_type :json
    sleep 3
    {message: "Sync api called: #{Time.now}"}.to_json
  end
end
