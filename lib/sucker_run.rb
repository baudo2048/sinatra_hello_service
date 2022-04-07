class SuckerRun
  include SuckerPunch::Job

  def initialize
    @logger = Logger.new($stdout)
  end

  def perform
    @logger.info "Starting background suckerpunch"
    ActiveRecord::Base.connection_pool.with_connection do
      BulkData.new.load_seed_tweets_firsttry
    end
    @logger.info "Completed background suckerpunch"
  end
end
