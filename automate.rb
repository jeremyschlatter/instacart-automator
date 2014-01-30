require 'rubygems'
require 'selenium-webdriver'
require 'watir'
require 'watir-webdriver'
require 'pry'
require 'trollop'
require 'headless'

load 'utility.rb'
load 'attribute_initializable.rb'
load 'cart.rb'
load 'item.rb'

opts = Trollop::options do
    opt :order_a, "Put Order A in cart"
    opt :order_b, "Put Order B in cart"
    opt :checkout, "Checkout at the end"
    opt :clear_cart, "Clear cart first"
    opt :user, "Instacart username", :type => :string
    opt :password, "Instacart password", :type => :string
end

if opts[:order_a]
    Item.define 39175, 3 # Barnstar Cage Free Eggs
    Item.define 39654, 1 # The Greek Gods Traditional Plain Greek Yogurt
    Item.define 42639, 2 # Organic Yellow Onions
    Item.define 39293, 1 # Lucerne Milk Whole
    Item.define 42557, 3 # Organic Banana
    Item.define 42899, 1 # Turtle Island Tofurky Italian Sausage
    Item.define 37686, 1 # Ghirardelli Chocolate Gourmet Bar Intense Dark Chocolate Midnight Reverie 86% Cacao
    Item.define 213639, 1 # Trail Blazer Blueberries
elsif opts[:order_b]
    Item.define 107917, 3 # eggs
    Item.define 108069, 1 # milk
    Item.define 97742, 1 # ice cream
    Item.define 97904, 1 # juice
    Item.define 109272, 1 # humus
    Item.define 106647, 1 # chips
    Item.define 100202, 1 # shredded cheese
    Item.define 106901, 1 # raspberries
    Item.define 219576, 1.25 # oranges
end

TARGET_URL_PREFIX="http://instacart.com"

puts "Launching Xvfb..."
headless = Headless.new
headless.start

# Initialize browser
puts "Initializing browser..."
@@browser = Watir::Browser.new

# Fetch Login page..."
puts "Fetching Login page..."
@@browser.goto "#{TARGET_URL_PREFIX}/accounts/login"

# Fill in the Login form
puts "Filling in Login form..."
@@browser.text_field(:name => "user[email]").set opts[:user]
@@browser.text_field(:name => "user[password]").set opts[:password]

@@browser.form(:id => "new_user").submit

if opts[:clear_cart]
    # Clear cart
    puts "Clearing cart..."
    Cart.clear
end

if !Item.items.empty?
    # Add items
    puts "Adding items..."
    Item.add_items
end

if opts[:checkout]
    puts "Placing order..."
    Cart.place_order
end

# Quit
puts "Quitting browser..."
@@browser.quit

headless.destroy
