require 'sinatra/base'
require 'json'
require 'logger'
require 'faker'
require 'active_record'
require 'sinatra/activerecord'
require_relative 'models/user'

class ServiceApp < Sinatra::Base
  before do
    @logger = Logger.new($stdout)
    @logger.info "Hello Paper Trail: this is servapp"
  end

  get "/api/user/add/ssync" do
    content_type :json
    @logger.info "Requesting: #{params[:user_count]}"
    create_random_user(params[:user_count].to_i)
    {message: "Sync api called: #{Time.now}"}.to_json
  end

  get "/api/user/add/async" do
    content_type :json
    Thread.new { create_random_user(params[:user_count].to_i) }
    {message: "Sync api called: #{Time.now}"}.to_json
  end

  def create_random_user(count)
    count.times { User.create(name: Faker::Name.name, email: Faker::Internet.email) }
  end
end
