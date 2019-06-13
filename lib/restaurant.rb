require_relative 'support/number_helper'
class Restaurant

  include NumberHealper
  @@filepath = nil

  attr_accessor :name, :cuisine, :price

  def initialize(args={}) #first defenation called automaticly
    @name    = args[:name]    || "" #set input and if user dosent set it worked.
    @cuisine = args[:cuisine] || ""
    @price   = args[:price]   || ""
  end #end of initialize defenation

  def self.buid_using_questions
    args = {} #define hash varaiable

    print "Restaurant name: "
    args[:name] = gets.chomp.strip # gets input and delete all space and tab whith strip methods

    print "Cuisine type: "
    args[:cuisine] = gets.chomp.strip # gets input and delete all space and tab whith strip methods

    print "Average price: "
    args[:price] = gets.chomp.strip # gets input and delete all space and tab whith strip methods

    return self.new(args) # self = Restaurant class (we inside the Restaurant class)
  end

  def formatted_price
    number_to_currency(@price)
  end

  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  def self.file_exists?
    #class should know if the resturant file exists
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    #create the resturant file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end

  def self.saved_restaurants
    restaurants = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
  end

  def import_line(line)
    line_array = line.split("\t")
    @name, @cuisine, @price = line_array
    return self
  end

  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
    end
    return true
  end

end