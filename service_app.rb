require 'sinatra/base'
require 'json'
require 'logger'
require 'faker'

class ServiceApp < Sinatra::Base
  before do
    @logger = Logger.new($stdout)
  end

  get "/api/sync/?" do
    @logger.info "Hello Paper Trail: this is servapp"
    content_type :json
    @logger.info params[:user_count]
    create_random(params[:user_count])
    {message: "Sync api called: #{Time.now}"}.to_json
  end

  def create_random_user(count)
    count.times { User.create(name: Faker::Name.name, email: Faker::Internet.email) }
  end
end
