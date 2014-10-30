require "rubygems"
require "watir-webdriver"
  
  # Update your information in this area///////////////////////
  userName = "mohamed_elzein@spe.sony.com" # add you email here
  password = "pa55w0rd" # add you pass here
  #///////////////////////////////////////////////////////////
  
  browser = Watir::Browser.new(:firefox) 
  browser.window.move_to(0, 0)
  browser.window.resize_to(1400, 1000)
  env = "http://qa.agorapic.com/"
  browser.goto env
  browser.text_field(:id, "Email").when_present.set(userName)
  browser.text_field(:id, "Password").when_present.set(password)
  browser.button(:class, "no-button").when_present.click
  if browser.link(:class, "logo").when_present.link
    puts "login successful."
  else
    puts "login failed"
  end
  
  # Add you code below this line ////////////////////////////

