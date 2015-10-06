class CreateMotorCycles < ActiveRecord::Migration
  def change
    create_table :motor_cycles do |t|
      t.integer :employee_id
      t.string :brands

      t.timestamps
    end
  end
end
