require 'sinatra/base'
require 'json'

class ServiceApp < Sinatra::Base
  def self.get_global key
    @globals[key]
  end

  def self.set_global key, value
    @globals[key] = value
  end

  def self.incr_global key
    if @globals[key].nil
      @globals[key] = 0
    else
      @globals[key] += 1
    end
    @globals[key]
  end

  get "/api/sync/?" do
    content_type :json
    { message: "Sync called #{self.incr_global(:counter)}"}.to_json
  end
end
