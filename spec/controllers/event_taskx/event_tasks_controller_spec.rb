require 'spec_helper'

module EventTaskx
  describe EventTasksController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @task_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'task_status')  
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns tasks" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id)
        task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :name => 'a new task')
        get 'index', {:use_route => :event_taskx_event_task}
        assigns[:event_tasks].should =~ [task, task1]
      end
      
      it "should only return the task for a resource_string" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_string => 'projectx/projects')
        task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :name => 'a new task')
        get 'index', {:use_route => :event_taskx_event_task, :resource_string => 'projectx/projects'}
        assigns[:event_tasks].should =~ [task]
      end
      
      it "should only return the task for the resource_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100)
        task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :name => 'a new task')
        get 'index', {:use_route => :event_taskx_event_task, :resource_id => 100}
        assigns[:event_tasks].should =~ [task]
      end
      
      it "should only return the task for the resource_id and resource_string" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100)
        task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :resource_string => 'projectx/projects',  :name => 'a new task')
        get 'index', {:use_route => :event_taskx_event_task, :resource_id => 100, :resource_string => ' projectx/projects'}
        assigns[:event_tasks].should =~ [task1]
      end
      
      it "should return the task for the task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "EventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production')
        task1 = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :resource_string => 'projectx/projects',  :name => 'a new task')
        get 'index', {:use_route => :event_taskx_event_task, :task_category => 'production'}
        assigns[:event_tasks].should =~ [task]
      end
      
      
    end
  
    describe "GET 'new'" do
      it "returns bring up new page with task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :event_taskx_event_task, :task_category => 'production'}
        response.should be_success
        assigns[:task_category].should eq('production')
      end
      
      it "should bring up new page without task_category" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :event_taskx_event_task}
        response.should be_success
         
      end
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :resource_string => 'projectx/projects')
        get 'create', {:use_route => :event_taskx_event_task, :event_task => task}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => nil, :resource_string => 'projectx/projects')
        get 'create', {:use_route => :event_taskx_event_task, :event_task => task}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production')
        get 'edit', {:use_route => :event_taskx_event_task, :id => task.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production')
        get 'update', {:use_route => :event_taskx_event_task, :id => task.id, :event_task => {:name => 'new name'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production')
        get 'update', {:use_route => :event_taskx_event_task, :id => task.id, :event_task => {:name => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.executioner_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:event_taskx_event_task, :task_status_id => @task_sta.id, :resource_id => 100, :task_category => 'production', :executioner_id => @u.id)
        get 'show', {:use_route => task.id, :id => task.id}
        response.should be_success
      end
    end
  
  end
end
