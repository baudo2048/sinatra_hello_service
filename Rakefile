require 'sinatra'
require 'active_record'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

namespace :db do
  task :load_config do
    require_relative "main_app"
  end
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end
