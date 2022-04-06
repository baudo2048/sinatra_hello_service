class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.integer :user_dent
      t.integer :text
      t.datetime :date
    end
  end
end
