Rails.application.routes.draw do
  get '/version', controller: :version, action: :index
end
