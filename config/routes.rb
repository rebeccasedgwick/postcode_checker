# frozen_string_literal: true

Rails.application.routes.draw do
  root 'postcode_checker#index'
  get 'postcode_checker/validate', to: 'postcode_checker#validate'

  resources :whitelisted_postcodes
end
