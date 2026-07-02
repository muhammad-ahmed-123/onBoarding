class User
  def initialize(name, email)
    @name = name
    @email = email
    @logged_in = false
  end 

  def login()
    @logged_in = true
    puts "#{@name} has logged in."
  end

  def logout()
    @logged_in = false
    puts "#{@name} has logged out."
  end
end

class Admin < User
  def initialize(name, email)
    super(name, email)
  end

  def ban_user(username)
    puts "#{@name} has banned #{username}."
  end

  def delete_post(post_id)
    puts "#{@name} has deleted post #{post_id}."
  end
end

class Customer < User
  def initialize(name, email)
    super(name, email)
    @cart = []
  end

  def purchase(item)
    puts "#{@name} has purchased #{item}."
  end

  def cart()
    @cart
  end
end

class Guest
  def browse(page)
    puts "Guest is browsing #{page}."
  end
end