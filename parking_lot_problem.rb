#!/usr/bin/ruby
require 'time'

$parking_lot = Hash.new()
$time = Time.now.strftime("%H:%M")
$car_log = []
$total_earnings = 0

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

  def arrival=(value)
    @arrival=value
  end

  def arrival
    @arrival
  end
  
  def departure=(value)
    @departure=value
  end

  def departure
    @departure
  end

  def initialize(plate_no, color, arrival)
    self.plate_no = plate_no
    self.color = color
    self.arrival = arrival
  end
end

def create_parking_lot(size, rate, grace_period) #Here
  $rate = rate
  $grace_period = grace_period
  size.times do |i|
    $parking_lot.store(i+1, nil)
  end
  puts "Created a parking lot with #{size} slots, #{rate} per hour, #{grace_period} minute(s) grace period\n" 
end

def park(plate_no, color)
  $parking_lot.each {|position, car| 
    if car == nil
      $parking_lot.store(position, Car.new(plate_no, color, Time.now.strftime("%H:%M")))
      puts "Allocated slot number: #{position}\n"
      return
    end
    if position == $parking_lot.size and car != nil
      puts "Sorry, parking lot is full\n"
    end
  }
end

def leave(plate_no)
  leaving_car = nil
  index = nil
  $parking_lot.each {|position, car|
    if car != nil
      if car.plate_no == plate_no
        index = position
        leaving_car = car
        break
      end
    end
  }
  if leaving_car != nil
    departure = Time.now.strftime("%H:%M")
    duration = Time.parse(departure) - Time.parse(leaving_car.arrival)
    hour_duration = (duration / 3600).floor
    fee = if (duration / 60 <= $grace_period) then 0 else hour_duration * rate end
    $car_log << { :plate_no => leaving_car.plate_no, :color => leaving_car.color, :arrival => leaving_car.arrival, :departure => departure}
    $total_earnings += fee
    $parking_lot[index] = nil
    puts "Slot number #{index+1} is free, paid #{'%.2f' % fee}\n"
  else
    puts "Unable to find #{plate_no}"
  end
end

def status
  puts "Slot No. Registration No Colour Arrival Departure\n"
  $parking_lot.each {|position, car|
    if car
      puts "#{position} #{car.plate_no} #{car.color} #{car.arrival} #{car.departure}"
    end
  }
  puts "Total no of cars serviced: #{$car_log.length}"
  puts "Total earnings: #{$total_earnings}"
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

  puts (if cars.size > 0 then "#{cars.join(", ")}\n" else "Not found\n" end)
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

  puts (if return_values.size > 0 then "#{return_values.join(", ")}\n" else "Not found\n" end)
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

  puts (if return_values.size > 0 then "#{return_values.join(", ")}\n" else "Not found\n" end)
end

def log
  $car_log.sort_by! {|car| car[:arrival]}
  puts "Car Log:"
  puts "Registration No Colour Arrival Departure\n"
  $car_log.each do |car|
    puts "#{car[:plate_no]} #{car[:color]} #{car[:arrival]} #{car[:departure]}"
  end
end

def number?(input)
  return (if input.match(/^\d+$/) == nil then false else true end)
end  

def currency?(input)
  return (if input.match(/^\d+\.\d{2}$/) == nil then false else true end)
end 

def parse_command(input)
  command, *parameters = input.split(" ")
  case command
  when "create_parking_lot"
    if parameters.length == 3 and parameters[0].to_i > 0 and number?(parameters[0]) and parameters[1].to_f >= 0 and currency?(parameters[1]) and parameters[2].to_i >= 0 and number?(parameters[2])
      create_parking_lot(parameters[0].to_i, parameters[1].to_f, parameters[2].to_i)
    else
      if parameters.length != 3
        puts "Invalid no. of arguments for create_parking_lot. Usage: create_parking_lot <size> <rate> <grace_period>\n"
      elsif not number?(parameters[0])
        puts "Invalid size. Size should be an integer greater than 0."
      elsif not currency?(parameters[1])
        puts "Invalid rate. Rate should be an float (xx.xx)"
      elsif not number?(parameters[2])
        puts "Invalid grace period format. Enter number in minutes."
      end
    end

  when "park"
    if parameters.length == 2
      park(parameters[0], parameters[1])
    else
      puts "Invalid no. of arguments for park. Usage: park <registration_no> <color>\n"
    end

  when "leave" 
    if parameters.length == 1
      leave(parameters[0])
    else
      puts "Invalid no. of arguments for leave. Usage: leave <plate_no>\n"
    end

  when "status"
    if parameters.length == 0
      status
    else
      puts "Invalid use of status. Usage: status\n"
    end

  when "registration_numbers_for_cars_with_colour"
    if parameters.length == 1
      registration_numbers_for_cars_with_colour(parameters[0])
    else
      puts "Invalid no. of arguments for registration_numbers_for_cars_with_colour. Usage: registration_numbers_for_cars_with_colour <color>\n"
    end

  when "slot_numbers_for_cars_with_colour"
    if parameters.length == 1
      slot_numbers_for_cars_with_colour(parameters[0])
    else
      puts "Invalid no. of arguments for slot_numbers_for_cars_with_colour. Usage: slot_numbers_for_cars_with_colour <color>\n"
    end

  when "slot_number_for_registration_number"
    if parameters.length == 1
      slot_number_for_registration_number(parameters[0])
    else
      puts "Invalid no. of arguments for slot_number_for_registration_number. Usage: slot_number_for_registration_number <registration_no>\n"
    end

  when "log"
    if parameters.length == 0
      log
    else
      puts "Invalid use of log. Usage: log\n"
    end

  when "exit"
    exit
  else
    puts "Unknown command: #{input}"
  end
end

if ARGV.length == 0
  while input = gets()
    parse_command(input)
  end
else
  filename = ARGV[0]
  if File.exists?filename
    File.open(filename, "r").each do |line|
      if not line.strip.empty?
        parse_command(line)   #=> Lorem ipsum etc.
      end
    end
  else
    puts "#{filename} does not exists"
  end
end
