Rails.application.routes.draw do
  get "/taxable_income", to: "taxable_income#show"

  get "/user",           to: "users#show"
  post "/new_user",      to: "users#new"

  get "/tax_brackets",          to: "tax_brackets#show"
  post "/tax_bracket/new",       to: "tax_brackets#new"
  post "/tax_bracket/update",   to: "tax_brackets#update"
end
