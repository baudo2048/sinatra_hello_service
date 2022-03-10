require 'sinatra/base'

class MainApp < Sinatra::Base
  get '/' do
    erb :home_page
  end
end
