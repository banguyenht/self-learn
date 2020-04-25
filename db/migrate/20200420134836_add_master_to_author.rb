class AddMasterToAuthor < ActiveRecord::Migration[6.0]
  def change
  	add_column :authors, :master, :boolean, default: true
  end
end
