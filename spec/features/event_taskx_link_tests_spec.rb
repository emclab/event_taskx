require 'rails_helper'

RSpec.describe "LinkTests" , type: :request do
  describe "GET /event_taskx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
                 'left-span#'         => '6', 
                 'offset#'         => '2',
                 'form-span#'         => '4'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "t('set'), t('piece')")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index_production_plan', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create_production_plan', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update_production_plan', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show_production_plan', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.executioner_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_production_plan', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        
      @task_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'task_status')  
      task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan', :executioner_id => @u.id)
        
            
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit event_taskx.event_tasks_path(:task_category => 'production_plan', :subaction => 'production_plan')
      save_and_open_page
      expect(page).to have_content('Production Plans')
      click_link('Edit')
      save_and_open_page
      fill_in 'event_task_name' , :with => 'this is a new task'
      click_button 'Save'
      save_and_open_page
      #wrong data
      visit event_taskx.event_tasks_path(:task_category => 'production_plan', :subaction => 'production_plan')
      expect(page).to have_content('Production Plans')
      click_link('Edit')
      fill_in :event_task_name , :with => ''
      click_button "Save"
      save_and_open_page
      
      visit event_taskx.new_event_task_path(:resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan', :subaction => 'production_plan')
      save_and_open_page
      task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production_plan', 
                                 :resource_string => 'projectx/projects', :executioner_id => @u.id)
      visit event_taskx.event_task_path(task1, :subaction => 'production_plan') #, :parent_record_id => task1.resource_id, :parent_resource => task1.resource_string)
      save_and_open_page
      click_link('New Log')
      save_and_open_page
      expect(page).to have_content('Log')
      
      visit event_taskx.event_tasks_path(:resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan', :subaction => 'production_plan')
      #save_and_open_page
      click_link('New Production Plan')
      save_and_open_page
      fill_in :event_task_name, :with => 'a new name'
      click_button 'Save'
      save_and_open_page
      #wrong data
      visit event_taskx.event_tasks_path(:resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan', :subaction => 'production_plan')
      click_link('New Production Plan')
      fill_in :event_task_name, :with => ''
      click_button 'Save'
      save_and_open_page
    end
  end
end
