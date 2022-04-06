class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :ident
      t.string :name
      t.string :email
      t.string :password_hash
      t.datetime :created
    end
  end
end
