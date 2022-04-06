class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.integer :star_ident
      t.integer :fan_ident
      t.datetime :created
    end
  end
end
