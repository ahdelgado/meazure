Rails.application.routes.draw do
  scope module: 'api', path: '', as: 'api' do
    resource :registrations, only: %i[create show]
  end
end
