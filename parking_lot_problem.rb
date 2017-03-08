#!/usr/bin/ruby

$parking_lot = Hash.new()

10.times do |i|
  $parking_lot.store(i+1, nil)
end

class Car
  def plate_no=(value)
    @plate_no=value
  end

  def plate_no
    @plate_no
  end

  def color=(value)
    @color=value
  end

  def color
    @color
  end

  def initialize(plate_no, color)
    self.plate_no = plate_no
    self.color = color
  end
end

def park(plate_no, color)
  $parking_lot.each {|position, car| 
    if car == nil
      $parking_lot.store(position, Car.new(plate_no, color))
      puts "Allocated slot number: #{position}"
      return
    end
    if position == $parking_lot.size and car != nil
      puts "Sorry, parking lot is full"
    end
  }
end

def leave(position)
  $parking_lot[position] = nil
  puts "Slot number #{position} is free"
end

def status
  puts "Slot No. Registration No Colour"
  $parking_lot.each {|position, car|
    if car
      puts "#{position} #{car.plate_no} #{car.color}"
    end
  }
end

def registration_numbers_for_cars_with_colour(color)
  cars = Array.new()
  $parking_lot.each {|position, car|
    if car
      if car.color == color
        cars.push(car.plate_no)
      end
    end
  }

  puts (if cars.size > 0 then "#{cars.join(", ")}" else "Not found" end)
end

def slot_numbers_for_cars_with_colour(color)
  return_values = Array.new()
  $parking_lot.each {|position, car|
    if car
      if car.color == color
        return_values.push(position)
      end
    end
  }

  puts (if return_values.size > 0 then "#{return_values.join(", ")}" else "Not found" end)
end

def slot_number_for_registration_number(plate_no)
  return_values = Array.new()
  $parking_lot.each {|position, car|
    if car
      if car.plate_no == plate_no
        return_values.push(position)
      end
    end
  }

  puts (if return_values.size > 0 then "#{return_values.join(", ")}" else "Not found" end)
end

#test case
park("KA-01-HH-1234", "White")
park("KA-01-HH-9999", "White")
park("KA-01-BB-0001", "Black")
park("KA-01-HH-7777", "Red")
park("KA-01-HH-2701", "Blue")
park("KA-01-HH-3141", "Black")
leave(4)
status
registration_numbers_for_cars_with_colour("White")
slot_numbers_for_cars_with_colour("Orange")
slot_numbers_for_cars_with_colour("White")
