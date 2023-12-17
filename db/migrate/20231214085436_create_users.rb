class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :login
      t.integer :github_id

      t.timestamps
    end
  end
end
