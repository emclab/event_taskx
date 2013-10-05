module EventTaskx
  class EventTask < ActiveRecord::Base
    attr_accessor :task_status_noupdate, :executioner_noupdate, :requested_by_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate
    attr_accessible :description, :cancelled, :completed, :executioner_id, :expedite, :finish_datetime, :instruction, :last_updated_by_id, :name, 
                    :requested_by_id, :resource_id, :resource_string, :start_datetime, :task_category, :task_status_id, :wfid, 
                    :as => :role_new
    attr_accessible :description, :cancelled, :completed, :executioner_id, :expedite, :finish_datetime, :instruction, :last_updated_by_id, :name, 
                    :requested_by_id, :start_datetime, :task_category, :task_status_id, :wfid, 
                    :task_status_noupdate, :executioner_noupdate, :requested_by_noupdate, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate,
                    :as => :role_update
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :executioner, :class_name => 'Authentify::User'
    belongs_to :task_status, :class_name => 'Commonx::MiscDefinition' 
    
    validates_presence_of :resource_id, :resource_string, :name  #, :task_status_id 
    
  end
end
