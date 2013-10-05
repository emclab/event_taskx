# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_taskx_event_task, :class => 'EventTaskx::EventTask' do
    resource_id 1
    resource_string "MyString"
    wfid "MyString"
    task_category "MyString"
    name "MyString"
    instruction "MyText"
    description "MyText"
    task_status_id 1
    start_datetime "2013-10-02 15:59:52"
    finish_datetime "2013-10-02 15:59:52"
    cancelled false
    completed false
    expedite false
    last_updated_by_id 1
    requested_by_id 1
    executioner_id 1
  end
end
