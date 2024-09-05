class AddColumnAlertTypeToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :alert_type, :string
    add_index :alerts, :alert_type
  end
end
