class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :user_id
      t.integer :project_id
      t.decimal :alloc_hours, precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end
