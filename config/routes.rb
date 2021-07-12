Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'download_and_parse_docs', to: 'docs#download_and_parse_docs'
  namespace 'api' do
    namespace 'v1' do
      resources :endpoints, only: [] do
        collection do
          get :download_and_parse_docs
        end
      end
    end
  end
end
