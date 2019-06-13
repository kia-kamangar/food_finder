require_relative "restaurant"
require_relative "support/string_extand"
class Guide

  class Config
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions; @@actions; end #for accessing acrions class varaible (we can only access to class varaiable in defitations)
  end #end of Config class

  def initialize(path=nil)
    Restaurant.filepath = path #path of restaurant class
    if Restaurant.file_usable?
      puts "Found restaurant file."
    elsif Restaurant.create_file
      puts "Created restaurant file."
    else
      puts "Exiting...\n\n"
      exit!
    end #end of if condation
  end #end of initialize defenation

  def launch!    #for execute Guide methods class
    introduction #Say hello and welcome
    # do action
    result = nil
    until result == :quit
      # what do you want to do? (list, find, add, quit)
      action, args = get_action
      # do that action
      result = do_action(action, args)
    end #end of until
    conclusion   #Say goodbye
  end #end of launch defenation

  def get_action #first check input string then give them to do_action
    # keep asking for user input until we get a valid action
    action = nil
      until Guide::Config.actions.include?(action)
        puts "Actions: " + Guide::Config.actions.join(", ") if action # if action => if user input is current. dont show Actions
        print "> "
        user_response = gets.chomp
        args = user_response.downcase.strip.split(" ")
        action = args.shift
      end #end of until
    return action, args
  end   #end of get_action

  def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift # args[0]
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end #end of case statement
  end   #end of do_action defenation

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

    output_action_header("Listing Restaurant")
    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1, r2|
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cuisine.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end #end of do
    end #end of unless

    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine\n\n"
  end #end of list defenation

  def find(keyword = '')
    output_action_header("Find a Restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key pharse to search the restaurant list"
    end
  end

  def add
    # puts "\nAdd a restaurant\n\n".upcase
    output_action_header("Add a Restaurant")

    restaurant = Restaurant.buid_using_questions

    if restaurant.save
      puts "\nRestaurant Added.\n\n"
    else
      puts "\nSave Error. Restaurant not added\n\n"
    end #end of if condition
  end

  def introduction
    puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
    puts "This is an intractive guide to help you find the food you crave.\n\n"
  end
  def conclusion
    puts "\n<<< Goodbye >>>\n\n"
  end

  private

  def output_action_header(text)
    puts "\n#{text.upcase.center(60)} \n\n"
  end

  def output_restaurant_table(restaurants  = [])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".rjust(6) + "\n"
    puts "-" * 60
    restaurants.each do |rest|
      line = " " << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    end
    puts "No listing found" if restaurants.empty?
    puts "-" * 60
  end
end
