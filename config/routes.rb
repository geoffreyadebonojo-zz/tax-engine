Rails.application.routes.draw do
  get "/taxable_income", to: "taxable_income#show"
end
