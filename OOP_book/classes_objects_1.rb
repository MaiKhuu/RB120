class Vehicle
    attr_accessor :year, :color, :model, :speed
  
  def initialize(y, c, m)
    self.year = y
    self.color = c
    self.model = m
    self.speed = 0
  end
  
  def speed_up(mph)
    self.speed += mph
  end
  
  def slow_down(mph)
    self.speed -= mph
  end
  
  def break
    self.speed = 0
  end
  
  def display_current_speed
    puts "#{speed} is the current speed"
  end
  
  def spray_paint(new_color)
    self.color = new_color
  end
  
  def self.mileage(gallons, miles)
    gallons.to_f/miles
  end
end

class MyCar < Vehicle
  def to_s
    "This is a #{color} #{model} car from #{year}"
  end
end

Ashley = MyCar.new(2018, "White", "Corolla")
p Ashley.to_s
