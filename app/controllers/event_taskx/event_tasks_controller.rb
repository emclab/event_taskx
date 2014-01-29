require_dependency "event_taskx/application_controller"

module EventTaskx
  class EventTasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
        
    def index
      @title = t(@task_category.humanize.titleize.pluralize)
      @event_tasks = params[:event_taskx_event_tasks][:model_ar_r]  #returned by check_access_right
      @event_tasks = @event_tasks.where('event_taskx_event_tasks.resource_id = ?', params[:resource_id]) if params[:resource_id].present? 
      @event_tasks = @event_tasks.where('TRIM(event_taskx_event_tasks.resource_string) = ?', params[:resource_string].strip) if params[:resource_string].present?
      @event_tasks = @event_tasks.where('TRIM(event_taskx_event_tasks.task_category) = ?', params[:task_category].strip) if params[:task_category].present?
      @event_tasks = @event_tasks.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('event_task_index_view', 'event_taskx')
    end
  
    def new
      @title = t('New ' + @task_category.humanize.titleize)
      @event_task = EventTaskx::EventTask.new()
      @erb_code = find_config_const('event_task_new_view', 'event_taskx')
    end
  
    def create
      @event_task = EventTaskx::EventTask.new(params[:event_task], :as => :role_new)
      @event_task.last_updated_by_id = session[:user_id]
      @event_task.requested_by_id = session[:user_id]
      if @event_task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @task_category = params[:event_task][:task_category].strip if params[:event_task].present? && params[:event_task][:task_category].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update ' + @task_category.humanize.titleize)
      @event_task = EventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_edit_view', 'event_taskx')
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
      @title = t(@task_category.humanize.titleize + ' Info')
      @event_task = EventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_show_view', 'event_taskx')
    end
    
    protected
    
    def load_record
      @task_category = params[:task_category].strip if params[:task_category].present?
      @resource_id = params[:resource_id] if params[:resource_id].present?
      @resource_string = params[:resource_string] if params[:resource_string].present?
      @task_category = EventTaskx::EventTask.find_by_id(params[:id]).task_category.strip if params[:id].present?
      @resource_id = EventTaskx::EventTask.find_by_id(params[:id]).resource_id if params[:id].present?
      @resource_string = EventTaskx::EventTask.find_by_id(params[:id]).resource_string if params[:id].present?
    end
    
  end
end
