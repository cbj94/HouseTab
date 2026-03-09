desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  puts "Sample data task running"

  # Clean out existing data
  ExpenseSplit.delete_all
  Settlement.delete_all
  Expense.delete_all
  Membership.delete_all
  Category.delete_all
  Household.delete_all
  User.delete_all

  puts "Deleted old data"

  # Create users
  users = []

  user_data = [
    { first_name: "Alice", last_name: "Johnson" },
    { first_name: "Steve", last_name: "Smith" },
    { first_name: "Carol", last_name: "Williams" },
    { first_name: "Dave", last_name: "Brown" },
    { first_name: "Eve", last_name: "Davis" },
  ]

  user_data.each do |data|
    u = User.new
    u.first_name = data[:first_name]
    u.last_name = data[:last_name]
    u.email = "#{data[:first_name].downcase}@example.com"
    u.password = "password"
    u.save

    users.push(u)
  end

  puts "Created #{User.count} users"

  # Create preset categories (no household)
  preset_names = ["Groceries", "Utilities", "Rent", "Supplies", "Other"]
  preset_names.each do |name|
    c = Category.new
    c.name = name
    c.save
  end

  puts "Created #{Category.count} preset categories"

  # Create households
  h1 = Household.new
  h1.name = "Apt 4B"
  h1.save

  h2 = Household.new
  h2.name = "The Lake House"
  h2.save

  puts "Created #{Household.count} households"

  # Create memberships
  # Apt 4B: Alice (creator), Bob, Carol, Dave
  Membership.create(user_id: users[0].id, household_id: h1.id, role: "creator")
  Membership.create(user_id: users[1].id, household_id: h1.id, role: "member")
  Membership.create(user_id: users[2].id, household_id: h1.id, role: "member")
  Membership.create(user_id: users[3].id, household_id: h1.id, role: "member")

  # The Lake House: Eve (creator), Alice, Bob
  Membership.create(user_id: users[4].id, household_id: h2.id, role: "creator")
  Membership.create(user_id: users[0].id, household_id: h2.id, role: "member")
  Membership.create(user_id: users[1].id, household_id: h2.id, role: "member")

  puts "Created #{Membership.count} memberships"

  # Grab categories for use in expenses
  groceries = Category.find_by(name: "Groceries")
  utilities = Category.find_by(name: "Utilities")
  rent = Category.find_by(name: "Rent")
  supplies = Category.find_by(name: "Supplies")

  # Create expenses for Apt 4B
  expenses_data = [
    { description: "Costco run", total_amount: 87.50, date: Date.today - 10, payer: users[0], category: groceries },
    { description: "Electric bill - March", total_amount: 120.00, date: Date.today - 7, payer: users[1], category: utilities },
    { description: "Toilet paper and paper towels", total_amount: 32.00, date: Date.today - 5, payer: users[2], category: supplies },
    { description: "Internet bill", total_amount: 80.00, date: Date.today - 3, payer: users[0], category: utilities },
    { description: "Trader Joes", total_amount: 65.00, date: Date.today - 1, payer: users[3], category: groceries },
  ]

  apt_members = [users[0], users[1], users[2], users[3]]

  expenses_data.each do |data|
    e = Expense.new
    e.description = data[:description]
    e.total_amount = data[:total_amount]
    e.date = data[:date]
    e.payer_id = data[:payer].id
    e.household_id = h1.id
    e.category_id = data[:category].id
    e.save

    # Split equally among all Apt 4B members
    split_amount = (data[:total_amount] / apt_members.length).round(2)
    apt_members.each do |member|
      es = ExpenseSplit.new
      es.expense_id = e.id
      es.user_id = member.id
      es.amount_owed = split_amount
      es.save
    end
  end

  # Create one expense for The Lake House
  lake_expense = Expense.new
  lake_expense.description = "Firewood and snacks"
  lake_expense.total_amount = 45.00
  lake_expense.date = Date.today - 2
  lake_expense.payer_id = users[4].id
  lake_expense.household_id = h2.id
  lake_expense.category_id = groceries.id
  lake_expense.save

  lake_members = [users[4], users[0], users[1]]
  lake_members.each do |member|
    es = ExpenseSplit.new
    es.expense_id = lake_expense.id
    es.user_id = member.id
    es.amount_owed = 15.00
    es.save
  end

  puts "Created #{Expense.count} expenses"
  puts "Created #{ExpenseSplit.count} expense splits"

  # Create a couple settlements for Apt 4B
  s1 = Settlement.new
  s1.payer_id = users[1].id
  s1.payee_id = users[0].id
  s1.household_id = h1.id
  s1.amount = 40.00
  s1.date = Date.today - 1
  s1.notes = "For the Costco run and internet"
  s1.save

  s2 = Settlement.new
  s2.payer_id = users[3].id
  s2.payee_id = users[0].id
  s2.household_id = h1.id
  s2.amount = 20.00
  s2.date = Date.today
  s2.notes = "Partial payback"
  s2.save

  puts "Created #{Settlement.count} settlements"

  puts "Sample data task finished"
  puts "-----"
  puts "You can sign in as any user with password 'password'"
  puts "For example: alice@example.com / password"
end
