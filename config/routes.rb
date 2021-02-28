Rails.application.routes.draw do
  get "/taxable_income", to: "taxable_income#show"
<<<<<<< Updated upstream
  
  get "/user",           to: "users#show"
  post "/new_user",      to: "users#new"
=======

  get "/user",           to: "users#show"
  post "/new_user",      to: "users#new"

  get "/tax_brackets",     to: "tax_brackets#show"
  post "/new_tax_bracket", to: "tax_brackets#new"
>>>>>>> Stashed changes
end
