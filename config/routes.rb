Rails.application.routes.draw do
  get "/taxable_income", to: "taxable_income#show"
  
  get "/user",           to: "users#show"
  post "/new_user",      to: "users#new"
end
