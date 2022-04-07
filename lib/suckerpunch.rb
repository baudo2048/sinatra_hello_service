require "sucker_punch"

class SuckerRun
  include SuckerPunch::Job

  def perform
    BulkData.new.load_seed_tweets_firsttry
  end
end
