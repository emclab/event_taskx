require_dependency "event_taskx/application_controller"

module EventTaskx
  class EventTasksController < ApplicationController
    before_filter :require_employee
        
    def index
      @title = t('Event Tasks')
      @event_tasks = params[:event_taskx_event_tasks][:model_ar_r]  #returned by check_access_right
      @event_tasks = @event_tasks.where('event_taskx_event_tasks.resource_id = ?', params[:resource_id]) if params[:resource_id].present? 
      @event_tasks = @event_tasks.where('TRIM(event_taskx_event_tasks.resource_string) = ?', params[:resource_string].strip) if params[:resource_string].present?
      @event_tasks = @event_tasks.where('TRIM(event_taskx_event_tasks.task_category) = ?', params[:task_category].strip) if params[:task_category].present?
      @event_tasks = @event_tasks.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('event_task_index_view', 'event_taskx_event_tasks')
    end
  
    def new
      @title = t('New Event Task')
      @event_task = EventTaskx::EventTask.new()
      @resource_id = params[:resource_id]
      @resource_string = params[:resource_string].strip
      @task_category = params[:task_category].strip if params[:task_category].present?
      @erb_code = find_config_const('event_task_new_view', 'event_taskx_event_tasks')
    end
  
    def create
      @event_task = EventTaskx::EventTask.new(params[:event_task], :as => :role_new)
      @event_task.last_updated_by_id = session[:user_id]
      @event_task.requested_by_id = session[:user_id]
      if @event_task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Event Task')
      @event_task = EventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_edit_view', 'event_taskx_event_tasks')
    end
  
    def update
      @event_task = EventTaskx::EventTask.find_by_id(params[:id])
      @event_task.last_updated_by_id = session[:user_id]
      if @event_task.update_attributes(params[:event_task], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Show Event Task')
      @event_task = EventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_show_view', 'event_taskx_event_tasks')
    end
    
    protected
    
  end
end
