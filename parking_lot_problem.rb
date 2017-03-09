#!/usr/bin/ruby

$parking_lot = Hash.new()

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

def create_parking_lot(size)
  size.times do |i|
    $parking_lot.store(i+1, nil)
  end
  puts "Created a parking lot with #{size} slots\n" 
end

def park(plate_no, color)
  $parking_lot.each {|position, car| 
    if car == nil
      $parking_lot.store(position, Car.new(plate_no, color))
      puts "Allocated slot number: #{position}\n"
      return
    end
    if position == $parking_lot.size and car != nil
      puts "Sorry, parking lot is full\n"
    end
  }
end

def leave(position)
  index = position.to_i
  $parking_lot[index] = nil
  puts "Slot number #{position} is free\n"
end

def status
  puts "Slot No. Registration No Colour\n"
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

def number?(input)
  return (if input.match(/^\d+$/) == nil then false else true end)
end  

def parse_command(input)
  command, *parameters = input.split(" ")
  case command
  when "create_parking_lot"
    if parameters.length == 1 and parameters[0].to_i > 0 and number?(parameters[0])
      create_parking_lot(parameters[0].to_i)
    else
      puts "Invalid no. of arguments for create_parking_lot. Usage: create_parking_lot <size>\n"
    end

  when "park"
    if parameters.length == 2
      park(parameters[0], parameters[1])
    else
      puts "Invalid no. of arguments for park. Usage: park <registration_no> <color>\n"
    end

  when "leave" 
    if parameters.length == 1 and parameters[0].to_i > 0 and parameters[0].to_i < $parking_lot.length and number?(parameters[0])
      leave(parameters[0].to_i)
    else
      puts "Invalid no. of arguments for leave. Usage: leave <slot_no>\n"
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

  when "exit"
    exit
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
