class Person
  attr_writer :name, :grade
  
  def initialize(n, g)
    @name = n
    @grade = g
  end
  
  def better_grade_than?(other_person)
    @grade > other_person.grade
  end
  
 protected
  
  def grade
    @grade
  end
end

joe = Person.new("Joe", 85)

bob = Person.new("Bob", 90)

puts "Well done!" if joe.better_grade_than?(bob)