require 'logger'
app_name = ENV["WHICH_APP"]
Logger.new($stdout).info app_name
if app_name == 'mainapp'
  require './main_app'
  Logger.new($stdout).info "Config.ru: starting mainapp"
  run MainApp
elsif app_name == 'servapp'
  Logger.new($stdout).info "Config.ru: starting servappApp"
  require './service_app'
  run ServiceApp
else
  abort %("Unknown Microservice #{service}. Check WHICH_APP environment variable!")
end
