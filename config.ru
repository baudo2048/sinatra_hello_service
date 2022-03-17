require 'remote_syslog_logger'
app_name = ENV["WHICH_APP"]
RemoteSyslogLogger.new('syslog.domain.com', 514,
                  :program => "launch",
                  :local_hostname => "optional_hostname").info app_name
if app_name == 'mainapp'
  puts("trace: Rack Starting Main")
  require './main_app'
  run MainApp
elsif app_name == 'servapp'
  puts("trace: Rack Starting Service")
  require './service_app'
  run ServiceApp
else
  abort %("Unknown Microservice #{service}. Check WHICH_APP environment variable!")
end
