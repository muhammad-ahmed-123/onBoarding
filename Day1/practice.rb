users = [
  {
    id: 1,
    name: "Alice",
    age: 24,
    active: true,
    country: "UK",
    purchases: [120, 45, 80]
  },
  {
    id: 2,
    name: "Bob",
    age: 17,
    active: false,
    country: "USA",
    purchases: [10]
  },
  {
    id: 3,
    name: "Charlie",
    age: 30,
    active: true,
    country: "Canada",
    purchases: [200, 300]
  },
  {
    id: 4,
    name: "David",
    age: 21,
    active: true,
    country: "USA",
    purchases: []
  }
]


puts "Task 1: Print all users"
users.each do |user|
  puts "User #{user[:id]}:#{user[:name]}"
end

puts "\nTask 2: Print all active users"


def print_active_users(users)
  active_users = []
  users.each do |user|
    if user[:active]
      active_users << user
    end  
  end
  return active_users
end


puts print_active_users(users)


puts "\nTask 3: Print all users which are above 21 years old"
def print_users_over_21(users)
  users_over_21 = []
  users.each do |user|
    if user[:age] > 21
      users_over_21 << user
    end
  end
  return users_over_21
end

puts print_users_over_21(users)


puts "\nTask 4: Print all users names"

def return_only_user_names(users)
  names = []
  users.each do |user|
    names << user[:name]

  end
  return names
end
puts return_only_user_names(users)



puts "Task 5: function to calculate the total revenue from all users purchases"
def calculate_total_revenue(users)
  total_revenue = 0
  users.each do |user|
    total_revenue += user[:purchases].sum
  end
  return total_revenue
end

puts calculate_total_revenue(users)


puts "Task 6: functoin to calculat hte highest spending user"
def highest_spending_user(users)
  highest_spender = nil
  highest_spending = 0
  users.each do |user|
    user_spending = user[:purchases].sum
    if user_spending > highest_spending
      highest_spending = user_spending
      highest_spender = user
    end
  end
  return highest_spender
end

puts highest_spending_user(users)



puts "Task 7;function to find the user with no purchases"
def user_with_no_purchases(users)
  users.each do |user|
    if user[:purchases].empty?
      return user
    end
  end
  return nil
end


puts user_with_no_purchases(users)



puts "Task 8; function to return the hashes"
def return_hashes()
  {
    "USA":2,
    "UK":3,
    "Canada":1
  }
end

puts return_hashes()


puts "Taks 9: return average purchase amount"
def return_average_purchase_amount(users)
  total_purchases = 0
  total_amount = 0
  users.each do |user|
    total_purchases += user[:purchases].length
    total_amount += user[:purchases].sum
  end
  return total_amount.to_f / total_purchases
end

puts return_average_purchase_amount(users)


