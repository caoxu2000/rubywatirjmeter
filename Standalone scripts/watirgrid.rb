require 'rubygems'
require 'watir-webdriver' 
#require 'watir' 
require 'watirgrid'
require 'controller'
require 'provider'





# Here's some basic examples in plain Ruby with Watirgrid and WebDriver

# Start a Controller using defaults
  controller = Controller.new
  controller.start

# Start 2 Providers with WebDriver
#1.upto(2) do
  provider = Provider.new(:driver => 'webdriver')
  provider.start
#end

# Control the Providers via the Grid
  Watir::Grid.new
  grid.start(:take_all => true)
