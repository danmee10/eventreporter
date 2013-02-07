require 'csv'
require_relative 'queue'


class EventReporter
attr_accessor :queue_temp
attr_accessor :current_csv


  def initialize
    puts "initializing..."
    @queue_temp = Queue.new
  end

  def load(file)
    file ? nil : file = "../event_attendees.csv"
    @current_csv = CSV.open("saved_queues/#{file}", :headers => true)
    puts "Loading #{file}"
  end

  def help(specific_command)
    if specific_command == ""
      command_list = ['Load <File Name>', 'Help', 'Help <command>', 'Queue Count', 'Queue Clear', 'Queue Print', 'Queue Print by <Attribute>', 'Queue Save to <Filename.csv>', 'Find <Attribute> <Criteria>']
      command_list.each do |c|
        puts c  
      end
    else 
      case specific_command
        when 'help' then puts "Prints a list of commands"
        when 'load' then puts "Loads specified file"
        when 'queue count' then puts "Outputs how many records are in the current queue"
        when 'queue clear' then puts "Empties queue"
        when 'queue print' then puts "Prints out a tab-delimited data table with a header row following this format:\n  LAST NAME  FIRST NAME  EMAIL  ZIPCODE  CITY  STATE  ADDRESS  PHONE"
        when 'queue print by' then puts "Prints the data table, sorted by the specified <attribute> (ex. zipcode)"
        when 'queue save to' then puts "Export the current queue to the specified <filename> as a CSV. The file should should include data and headers for last name, first name, email, zipcode, city, state, address, and phone number."
        when 'find' then puts "Loads the queue with all records matching the cirteria for the given <attribute>"
        else
          puts "Invalid command"
      end
    end
  end

  def clean_zip(zip)
    if zip.nil?
      "XXXXX"
    else 
      zip = "0" * (5 - zip.length) + zip
    end
  end

  def zipcode_search(zip)
    @queue_temp.clear
    if @current_csv !=nil
    @current_csv.each do |row|
      cleaned_zipcode = clean_zip(row["Zipcode"])
      if cleaned_zipcode.include?(zip)
       @queue_temp.push(row)
       #puts row
      end
    end
      @current_csv.rewind
      puts "Results added to queue"
    end
      puts "no results"
  end

  def first_name_search(first_name)
    @queue_temp.clear
    name = first_name.downcase
    if @current_csv != nil
    @current_csv.each do |row|
      formatted_first_name = row["first_Name"].downcase
      if formatted_first_name.include?(name) && formatted_first_name.length == name.length
        @queue_temp.push(row)
        #puts row
      end
    end
      @current_csv.rewind
      puts "Results added to queue"
    end
      puts "no results"
  end

  def last_name_search(last_name)
    @queue_temp.clear
    name = last_name.downcase
    if @current_csv != nil
    @current_csv.each do |row|
      formatted_last_name = row["last_Name"].downcase
      if formatted_last_name.include?(name) && formatted_last_name.length == name.length
        @queue_temp.push(row)
        #puts row
        end
      end
        @current_csv.rewind
        puts "Results added to queue"
      end
      puts "no results"
  end

  def clean_city_name(cn)
    if cn == nil
      cn = "XXXXX"
    else
      cn.downcase
    end
  end

  def city_search(city)
    @queue_temp.clear
    city_name = city.downcase
    if @current_csv != nil
    @current_csv.each do |row|
     formatted_city_name = clean_city_name(row["City"])
      if formatted_city_name.include?(city_name) && formatted_city_name.length == city_name.length
        @queue_temp.push(row)
        #puts row
        end
      end
        @current_csv.rewind
        puts "Results added to queue"
      end
      puts "no results"
  end

  def clean_state_name(sn)
    if sn == nil
      sn = "XX"
    else
      sn.upcase
    end
  end  

  def state_search(state)
    @queue_temp.clear
    state_name = state.upcase
    if @current_csv != nil
    @current_csv.each do |row|
      formatted_state_name = clean_state_name(row["State"])
      if formatted_state_name.include?(state_name) && formatted_state_name.length == state_name.length
        @queue_temp.push(row)
        #puts row
        end
      end
        @current_csv.rewind
        puts "Results added to queue"
      end
      puts "no results"
  end

  def find(attribute, criteria)
#why are att/crit being assigned random shit when i type nothing in?
    # if attribute || criteria == nil
    #  puts "Find what?" 
    # else
    # # search = Queue.new
    #   @current_csv.collect do |line|
    #   attribute = line[criteria]
    #   search << first_name
    # end
   case attribute.downcase
     when 'zipcode' then
     zipcode_search(criteria)
     when 'first_name' then first_name_search(criteria)
     when 'last_name' then last_name_search(criteria)
     when 'city' then city_search(criteria)
     when 'state' then state_search(criteria)
     else
      puts 'Invalid attribute'
   end
  end

  def headers
    @current_csv.read
    results = @current_csv.headers
    @current_csv.rewind
    return results
  end

  def queue_opps(action, specification=nil)
    case action
    when 'count' then puts @queue_temp.count
    when 'clear' then @queue_temp.clear
    when 'save'  then @queue_temp.save(specification)
    when 'print' then 
      if specification == nil
        puts @queue_temp
      else
        @queue_temp.print_by(specification)
      end
    else
      puts "Invalid action on queue"
    end
  end

  def run
    command = ""
    while command != "q"
      printf "Please enter command: "
      input = gets.chomp.downcase
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye"
        when 'load' then load(parts[1])
        when 'help' then help(parts[1..-1].join(" "))
        when 'queue' then queue_opps(parts[1], parts[3])
        when 'find' then 
          if parts[1] == nil || parts[2] == nil
            puts "invalid search"
            else
            find(parts[1], parts[2..-1].join(" "))
            end
        else
          puts "Invalid command"
        end
    end
  end



end

er = EventReporter.new
er.run









