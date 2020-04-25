class AddAvailbleToBooks < ActiveRecord::Migration[6.0]
  def change
  	add_column :books, :available, :boolean, default: true
  end
end
