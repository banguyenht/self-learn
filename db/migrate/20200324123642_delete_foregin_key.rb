class DeleteForeginKey < ActiveRecord::Migration[6.0]
  def change
  	remove_foreign_key :products, column: :category_id
  	remove_foreign_key :products, column: :discount_id
  end
end
