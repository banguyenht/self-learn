class CreateImages < ActiveRecord::Migration[6.0]
  def change
  	drop_table :images
    create_table :images do |t|
      t.string :url
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
