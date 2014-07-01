class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :slug, index: true
      t.index :slug
      t.timestamps
    end
  end
end
