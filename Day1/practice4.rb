module Greetable
  def greet
    puts "Hello, I am #{name}."
  end
end

module Describable
  def describe
    puts "#{name} is a class for representing people."
  end
end

module Loud
  def speak
    "#{super.upcase}!"
  end
end

class Person
  include Greetable
  extend Describable
  prepend Loud

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    "hi there"
  end
end

person = Person.new("Alice")

person.greet
Person.describe
puts person.speak

puts Person.ancestors.inspect
