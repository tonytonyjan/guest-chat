class AddRoleToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :role, :string
  end
end
