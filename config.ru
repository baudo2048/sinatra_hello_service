app_name = ENV["WHICH_APP"]
puts service
if service == 'mainapp'
  puts("trace: Rack Starting Main")
  require './main_app'
  run MainApp
elsif service == 'servapp'
  puts("trace: Rack Starting App")
  require './service_app'
  run ServiceApp
else
  abort %("Unknown Microservice #{service}. Check WHICH_APP environment variable!")
end
