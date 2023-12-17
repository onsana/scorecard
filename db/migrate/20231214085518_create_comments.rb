class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.integer :github_id
      t.references :user, null: false, foreign_key: true
      t.date :date_created

      t.timestamps
    end
  end
end
