class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.date :date
      t.string :rationale
      t.string :text

      t.timestamps null: false
    end
  end
end
