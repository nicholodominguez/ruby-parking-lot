#!/usr/bin/ruby

$parking_lot = Hash.new()

10.times do |i|
  $parking_lot.store(i+1, nil)
end

class Car
  def initialize(plate_no, color)
    @plate_no = plate_no
    @color = color
  end

  def print
    puts "#{@plate_no} #{@color}"
  end
end

def park(plate_no, color)
  $parking_lot.each {|position, car| 
    if car == nil
      $parking_lot.store(position, Car.new(plate_no, color))
      return
    end
  }
end

def leave(position)
  $parking_lot[position] = nil
  puts "Slot number #{position} is free"
end


#test case
park("KA-01-HH-1234", "White")
park("KA-01-HH-9999", "White")
park("KA-01-BB-0001", "Black")
park("KA-01-HH-7777", "Red")
park("KA-01-HH-2701", "Blue")
park("KA-01-HH-3141", "Black")
leave(4)

puts $parking_lot.inspect


