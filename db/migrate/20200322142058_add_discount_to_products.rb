class AddDiscountToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :discount, foreign_key: true
  end
end
