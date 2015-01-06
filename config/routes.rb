require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # so the application will always look under app/controller/api for the controller code
  namespace :api,
            # default respond_to is json...
            defaults: { format: :json,
                        # ...when the subdomain is 'api.<app host>'...
                        constraints: { subdomain: 'api' },
                        # ...and serve the root path rather than defaulting to /api/
                        path: '/'
                      } do
    # we're versioning the api, so this'll set resources up under /v1/ | app/controllers/api/v1/
    scope module: :v1,
          # this obj will return true for Accept and just 'cuz
          constraints: ApiConstraints.new(version: 1, default: true) do
      # v1 resources
      resources :users, :only => [:show]
    end
      
  end
end
