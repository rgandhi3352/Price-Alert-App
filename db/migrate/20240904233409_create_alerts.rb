class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.integer :coin, default: 0
      t.float :target_price
      t.timestamps
    end
  end
end
