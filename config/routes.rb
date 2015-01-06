Rails.application.routes.draw do
  # so the application will always look under app/controller/api for the controller code
  namespace :api,
            # default respond_to is json...
            defaults: { format: :json
                        # ...when the subdomain is 'api.<app host>'...
                        constraints: { subdomain: 'api' },
                        # ...and serve the root path rather than defaulting to /api/
                        path: '/'
                      } do
    # we're versioning the api, so this'll set resources up under /v1/ | app/controllers/api/v1/
    scope module: :v1 do
      
    end
  end
end
