require 'csv'
require_relative '../main_app'
class BulkData
  def initialize
    @logger = Logger.new($stdout)
  end

  def load_all_seed_users
    csv = CSV.read('db/seeds/users.csv', headers: true)
    csv_array_of_hash = csv.map(&:to_h)
    User.insert_all csv_array_of_hash
  end

  def delete_all_users
    User.delete_all
  end

  def delete_all_follows
    Follow.delete_all
  end

  def delete_all_tweets
    Tweet.delete_all
  end

  def load_all_follows
    csv = CSV.read('db/seeds/follows.csv', headers: true)
    csv_array_of_hash = csv.map(&:to_h)
    idents = User.all.pluck(:ident)
    follows_records = csv_array_of_hash.filter { |r| idents.intersect?([r["star_ident"], r["fan_ident"]]) }
    Follow.insert_all follows_records
  end

  def load_seed_tweets_firsttry
    @logger.info("Running seed_tweets_firsttry")
    idents = User.all.pluck(:ident)
    CSV.foreach('db/seeds/tweets.csv', headers: true) do |row|
      if idents.include? row["user_ident"]
        Tweet.insert row.to_h
      end
    end
    @logger.info("Completed seed_tweets_firsttry")
  end

  def load_seed_tweets_faster
    idents = User.all.pluck(:ident)
    tweets_to_add = []
    CSV.foreach('db/seeds/tweets.csv', headers: true) do |row|
      if idents.include? row["user_ident"]
        tweets_to_add << row.to_h
      end
    end
    Tweet.insert_all tweets_to_add
  end

  def validate_user user
    u = User.find(user)
    @logger.info("Real Validation on user #{u.name}")
    fans = u.fans
    stars = u.stars
  end
end
