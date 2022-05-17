class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title, null: false, unique: true
      t.string :url, null: false, unique: true
      t.datetime :publication_date
      t.string :image_link
      t.text :annonce
      t.text :body

      t.timestamps
    end
  end
end
