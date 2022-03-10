service = ENV["WHICH_APP"]
$stdout.sync = true

if service == 'main'
  puts("trace: Rack Starting Main")
  require './main_app'
  run MainApp
elsif service == 'service'
  puts("trace: Rack Starting App")
  require './service_app'
  run ServiceApp
else
  abort %("Unknown Microservice #{service}. Check WHICH_APP environment variable!")
end
