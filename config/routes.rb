Rails.application.routes.draw do
  # Routes for the Settlement resource:

  # CREATE
  post("/insert_settlement", { :controller => "settlements", :action => "create" })

  # READ
  get("/settlements", { :controller => "settlements", :action => "index" })

  get("/settlements/:path_id", { :controller => "settlements", :action => "show" })

  # UPDATE

  post("/modify_settlement/:path_id", { :controller => "settlements", :action => "update" })

  # DELETE
  get("/delete_settlement/:path_id", { :controller => "settlements", :action => "destroy" })

  #------------------------------

  # Routes for the Expense split resource:

  # CREATE
  post("/insert_expense_split", { :controller => "expense_splits", :action => "create" })

  # READ
  get("/expense_splits", { :controller => "expense_splits", :action => "index" })

  get("/expense_splits/:path_id", { :controller => "expense_splits", :action => "show" })

  # UPDATE

  post("/modify_expense_split/:path_id", { :controller => "expense_splits", :action => "update" })

  # DELETE
  get("/delete_expense_split/:path_id", { :controller => "expense_splits", :action => "destroy" })

  #------------------------------

  # Routes for the Expense resource:

  # CREATE
  post("/insert_expense", { :controller => "expenses", :action => "create" })

  # READ
  get("/expenses", { :controller => "expenses", :action => "index" })

  get("/expenses/:path_id", { :controller => "expenses", :action => "show" })

  # UPDATE

  post("/modify_expense/:path_id", { :controller => "expenses", :action => "update" })

  # DELETE
  get("/delete_expense/:path_id", { :controller => "expenses", :action => "destroy" })

  #------------------------------

  # Routes for the Membership resource:

  # CREATE
  post("/insert_membership", { :controller => "memberships", :action => "create" })

  # READ
  get("/memberships", { :controller => "memberships", :action => "index" })

  get("/memberships/:path_id", { :controller => "memberships", :action => "show" })

  # UPDATE

  post("/modify_membership/:path_id", { :controller => "memberships", :action => "update" })

  # DELETE
  get("/delete_membership/:path_id", { :controller => "memberships", :action => "destroy" })

  #------------------------------

  # Routes for the Category resource:

  # CREATE
  post("/insert_category", { :controller => "categories", :action => "create" })

  # READ
  get("/categories", { :controller => "categories", :action => "index" })

  get("/categories/:path_id", { :controller => "categories", :action => "show" })

  # UPDATE

  post("/modify_category/:path_id", { :controller => "categories", :action => "update" })

  # DELETE
  get("/delete_category/:path_id", { :controller => "categories", :action => "destroy" })

  #------------------------------

  # Routes for the Household resource:

  # CREATE
  post("/insert_household", { :controller => "households", :action => "create" })

  # READ
  get("/households", { :controller => "households", :action => "index" })

  get("/households/:path_id", { :controller => "households", :action => "show" })

  # UPDATE

  post("/modify_household/:path_id", { :controller => "households", :action => "update" })

  # DELETE
  get("/delete_household/:path_id", { :controller => "households", :action => "destroy" })

  #------------------------------

  devise_for :users
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end
