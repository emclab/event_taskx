class CreateEventTaskxEventTasks < ActiveRecord::Migration
  def change
    create_table :event_taskx_event_tasks do |t|
      t.integer :resource_id
      t.string :resource_string
      t.string :wfid
      t.string :task_category
      t.string :name
      t.text :instruction
      t.text :description
      t.integer :task_status_id
      t.datetime :start_datetime
      t.datetime :finish_datetime
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.boolean :expedite, :default => false
      t.integer :last_updated_by_id
      t.integer :requested_by_id
      t.integer :executioner_id

      t.timestamps
      
    end
    
    add_index :event_taskx_event_tasks, :resource_id
    add_index :event_taskx_event_tasks, :resource_string
    add_index :event_taskx_event_tasks, :task_category
    add_index :event_taskx_event_tasks, [:resource_id, :resource_string]
  end
end
