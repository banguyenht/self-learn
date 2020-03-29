class ChangeUnitDiscountToInteger < ActiveRecord::Migration[6.0]
  def change
  	change_column :discounts, :unit, :integer
  end
end
