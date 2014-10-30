require 'rubygems'
require 'watir-webdriver'
require 'selenium-webdriver'
require 'watirgrid'

def testPABuyFlow()
  browser.goto("http://www.proactiv.com")
  browser.span(:class, 'orngBtnBig').when_present.click
  ### Contact info ###
  browser.text_field(:id, 'email').when_present.set 'qa@gr.com'
  browser.text_field(:id, 'phone1').when_present.set '310'
  browser.text_field(:id, 'phone2').when_present.set '581'
  browser.text_field(:id, 'phone3').when_present.set '6250'
  ### Billing info ###
  browser.text_field(:id, 'billFirstName').when_present.set 'Gunjan'
  browser.text_field(:id, 'billLastName').when_present.set 'Dedhia'
  browser.text_field(:id, 'billAddress').when_present.set '3340 Ocean Park Blvd'
  browser.text_field(:id, 'billCity').when_present.set 'Santa Monica'
  browser.select_list(:id, 'billState').when_present.select 'CA'
  browser.text_field(:id, 'billZip').when_present.set '90405'
  ### Payment info ###
  browser.text_field(:id, 'creditCardNumber').when_present.set '4111111111111111'
  browser.select_list(:id, 'creditCardMonth').select '01-January'
  browser.select_list(:id, 'creditCardYear').select '2023'
  browser.checkbox(:id, 'dwfrm_personinf_agree').when_present.click
  browser.button(:id, 'contYourOrder').when_present.click
  if !browser.div(:class, 'errorform').when_present.text.include? 'We are having trouble authorizing your card, please enter an alternative card or try re-entering your card'
	case id
	  when '1'
		puts "watirgrid test failed in IE"
	  when '2'
		puts "watirgrid test failed in firefox"
	  when '0'
		puts "watirgrid test failed in Chrome" 
	else
	  puts "test failed with exception"
	end
  end
  browser.send_keys :space
  browser.send_keys :space
  browser.send_keys :space
  browser.send_keys :space
  browser.button(:id, 'contYourOrder').wait_until_present
  browser.button(:id, 'contYourOrder').when_present.click
  if browser.div(:class, 'checkout_header').h1.when_present.text.include? 'Checkout: Your Order Is Complete'
	order_number = browser.div(:id, 'orderConfirmNum').when_present.text
	case id
	  when '0'
		puts "Order# in Win7 IE is #{order_number}"
	  when '1'
		puts "Order# in Win7 Firefox is #{order_number}"
	  when '2'
		puts "Order# in in Win7 Chrome is #{order_number}" 
	else
	  puts "test failed with exception"
	end 
  end
  browser.close
end
Watir::Grid.control(:controller_uri => 'druby://10.45.17.6:11235') do |browser, id|
  testPABuyFlow()
end