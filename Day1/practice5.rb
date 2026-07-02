class Circle
  attr_accessor :radius

  @@count = 0

  def initialize(radius)
    @radius = radius
    @@count += 1
  end

  def area
    Math::PI * @radius**2
  end

  def circumference
    2 * Math::PI * @radius
  end

  def self.count
    @@count
  end
end


class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def balance
    @balance
  end

  def deposit(amount)
    self.balance = @balance + amount
  end

  def withdraw(amount)
    if amount <= @balance
      self.balance = @balance - amount
    else
      puts "Insufficient funds"
    end
  end

  private

  def balance=(amount)
    @balance = amount
  end
end