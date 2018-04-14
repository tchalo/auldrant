Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  # constraints :subdomain => 'api' do
  constraints subdomain: "api" do
    scope module: :api do
      scope module: :v1, as: 'api' do

      end
    end
  end
end
