Rails.application.routes.draw do
  root 'postcode_checker#index'
  get 'postcode_checker/validate', to: 'postcode_checker#validate'
end
