require 'csv'
require_relative '../main_app'
class BulkData
  def load_all_seed_users
    csv = CSV.read('db/seeds/users.csv', headers: true)
    csv_array_of_hash = csv.map(&:to_h)
    User.insert_all csv_array_of_hash
  end

  def delete_all_users
    User.delete_all
  end

  def load_all_follows
    csv = CSV.read('db/seeds/follows.csv', headers: true)
    csv_array_of_hash = csv.map(&:to_h)
    idents = User.all.pluck(:ident)
    follows_records = csv_array_of_hash.filter { |r| idents.intersect?([r["star_ident"], r["fan_ident"]]) }
    Follow.insert_all follows_records
  end
end
