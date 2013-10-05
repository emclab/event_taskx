EventTaskx::Engine.routes.draw do
  resources :event_tasks

  root :to => 'event_tasks#index'
end
