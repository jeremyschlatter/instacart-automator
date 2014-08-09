require 'rubygems'
require 'selenium-webdriver'
require 'watir'
require 'watir-webdriver'
require 'pry'
require 'trollop'
require 'headless'
require 'yaml'

load 'utility.rb'
load 'attribute_initializable.rb'
load 'cart.rb'
load 'item.rb'

opts = Trollop::options do
    opt :checkout, "Checkout at the end"
    opt :clear_cart, "Clear cart first"
    opt :user, "Instacart username", :type => :string, :required => true
    opt :password, "Instacart password", :type => :string, :required => true
end

data = YAML::load(STDIN.read)
data.each do |hash|
    hash.each do |k, v|
        Item.define k, v
    end
end

if Item.items.empty? && !opts[:checkout] && !opts[:clear_cart]
    puts "Nothing to do, quitting."
end

TARGET_URL_PREFIX="http://instacart.com"

puts "Launching Xvfb..."
headless = Headless.new
headless.start

# Initialize browser
puts "Initializing browser..."
$browser = Watir::Browser.new

# Fetch Login page..."
puts "Fetching Login page..."
$browser.goto "#{TARGET_URL_PREFIX}/accounts/login"

# Fill in the Login form
puts "Filling in Login form..."
$browser.text_field(:name => "user[email]").set opts[:user]
$browser.text_field(:name => "user[password]").set opts[:password]

$browser.form(:id => "new_user").submit

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
$browser.quit

headless.destroy
