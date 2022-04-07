class SuckerRun
  include SuckerPunch::Job

  def initialize
    @logger = Logger.new($stdout)
  end

  def perform
    @logger.info "starting background suckerpunch"
    BulkData.new.load_seed_tweets_firsttry
  end
end
