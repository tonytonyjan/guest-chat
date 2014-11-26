class ChangeGuestsRoleDefault < ActiveRecord::Migration
  def up
    change_column(:guests, :role, :string, null: false, default: :student) 
  end

  def down
    change_column(:guests, :role, :string, null: true, default: nil) 
  end
end
