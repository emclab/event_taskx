require 'spec_helper'

describe "LinkTests" do
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
         'mini-link'    => mini_btn +  'btn btn-link'
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
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.executioner_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_event_task', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
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
      visit event_tasks_path(:task_category => 'production_plan')
      #save_and_open_page
      page.body.should have_content('Production Plans')
      click_link('Edit')
      #save_and_open_page
      visit new_event_task_path(:resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan')
      #save_and_open_page
      task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production_plan', 
                                 :resource_string => 'projectx/projects', :executioner_id => @u.id)
      visit event_task_path(task1) #, :parent_record_id => task1.resource_id, :parent_resource => task1.resource_string)
      #save_and_open_page
      click_link('New Log')
      #save_and_open_page
      page.body.should have_content('Log')
      
      visit event_tasks_path(:resource_id => 100, :resource_string => 'projectx/projects', :task_category => 'production_plan')
      save_and_open_page
      click_link('New Production Plan')
      save_and_open_page
    end
  end
end
