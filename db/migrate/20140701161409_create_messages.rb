class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.references :guest, index: true
      t.references :room, index: true

      t.timestamps
    end
  end
end
