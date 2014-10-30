require "templates/blueGreen/template.rb"
def ci_Setup(whichApp, whichEnv)  # multiBrowser) # This is the setup: Sets Browser and Env then it launches the browser
  $totalTests = 0
  $totalPassed = 0
  $totalFailed = 0
  $failureName = ''
  $screenCaptureImageFileName = ''
  $app = whichApp
  if whichApp == 'MB'
    browserReadExcel()
  end
  loginReadExcel()
  invalidLoginReadExcel()
  envReadExcel(whichApp, whichEnv)
  writeTestResultHtmlHeader()
  launch_browser()  # when run in watirgrid, comment out this line
end

def ws_Logout()
  begin
    if $isTestingTeamsite
      $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').wait_until_present
      $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
    else
      $browser.li(:class, 'dropdown user').link(:class, 'dropdown-toggle').wait_until_present
      $browser.li(:class, 'dropdown user').link(:class, 'dropdown-toggle').when_present.click
    end
    $browser.link(:text, 'Logout').wait_until_present
    $browser.link(:text, 'Logout').when_present.click
    ci_ScreenCapture("LogoutText")
    mcs_assertion("AND...YOU'RE OUT", 'Ci Workspace Logout Test', 'h1', 'text', 'And...you\'re out')
    $browser.img(:alt, 'Ci').wait_until_present
    $browser.img(:alt, 'Ci').when_present.click
  rescue 
    ci_ScreenCapture("ws_Logout_Exception_Fail")
    mcs_failed_increment("ws_Logout")
  end
end

def mcs_Logout()
  log_out_link = $browser.link(:text => 'Sign Out')
  if log_out_link.exist?
    $browser.link(:class, 'logo').when_present.click
    $browser.span(:id, 'userAccountName').when_present.click
    $browser.link(:text, 'Sign Out').when_present.click
    $browser.wait()
    mcs_text_assertion('Logout',"Login")
  end
end

def mcs_TearDown() # This is the teardown: closes the browser (More to be added)
  mcs_Logout()
  $browser.close
  writeSummaryAndOverview()
  writeTestResultHtmlFooter()
end

def mcs_Amit_TearDown() # This is the teardown: closes the browser (More to be added)
  if $browser.exists?
    $browser.close
  end
  if $browser2.exists?
    $browser2.close
  end
  writeSummaryAndOverview()
  writeTestResultHtmlFooter()
end

def mcs_XuTearDown() # This is the teardown: closes the browser (More to be added)
  mcs_Logout()
  $browser.close
  writeSummaryAndOverview()
  writeTestResultHtmlFooter()
end

def ws_TearDown() # This is the teardown: closes the browser (More to be added)
  $browser.close
  writeSummaryAndOverview()
  writeTestResultHtmlFooter()
end

def mcs_assertion(a, n, e, at, atv)
  $totalTests += 1   #increment total tests # by 1
  assertion = a
  testName = n
  element = e
  attribute = at
  $attribute_value = atv
  if $browser.element(:"#{attribute}", $attribute_value).when_present.text.include? assertion
     $testStatus = 'Passed'
     $totalPassed += 1  #increment total passed tests # by 1
     puts testName + ' - Passed' 
  else  
     $totalFailed += 1  #increment total failed tests # by 1
     $failureName = $failureName + '<tr><td style="background: red"><strong>' + testName + '</strong></td><td style="background: red"></td></tr>'
     $testStatus = 'Failed'
     puts testName + ' - Failed'
  end
  writeTestResults(testName, assertion)
end

def mcs_assertPassed(testName, testAssertion, testStatus, testAttributeValue)
  $totalTests +=1
  assertion = testAssertion
  testName = testName
  $attribute_value = testAttributeValue
  testStatus = testStatus
  if testStatus == 'Passed'
     $totalPassed += 1  #increment total passed tests # by 1
     puts testName + ' - Passed' 
  else  
     $totalFailed += 1  #increment total failed tests # by 1
     $failureName = $failureName + '<tr><td style="background: red"><strong>' + testName + '</strong></td><td style="background: red"></td></tr>'
     puts testName + ' - Failed'
  end
  $testStatus = testStatus
  writeTestResults(testName, assertion)
end

def mcs_failed_increment(testName)
  testName = testName
  $totalTests += 1
  $failureName = $failureName + '<tr><td style="background: red"><strong>' + testName + '</strong></td><td style="background: red"></td></tr>'
  $totalFailed += 1  #increment total failed tests # by 1
  $testStatus = 'Failed'
  puts testName + ' - Failed'
  writeTestResults(testName, $testStatus)
end

def mcs_text_assertion(testName,assertion)
   testName = testName
   assertion = assertion
   $totalTests += 1   #increment total tests # by 1
   if $browser.html.include? assertion
     $testStatus = 'Passed'
     $totalPassed += 1  #increment total passed tests # by 1
     puts testName + ' - Passed'
     writeTestResults(testName, assertion)
  else  
     $totalFailed += 1  #increment total failed tests # by 1
     $failureName = $failureName + '<tr><td style="background: red"><strong>' + testName + '</strong></td><td style="background: red"></td></tr>'
     $testStatus = 'Failed'
     puts testName + ' - Failed'
     writeTestResults(testName, assertion)
  end
end

def mcs_assertElementPresent(testName, testElement, testAttribute, testAttributeValue)
  $totalTests += 1   #increment total tests # by 1
  testName = testName
  element = testElement
  attribute = testAttribute
  $attribute_value = testAttributeValue
  if $browser.element(:"#{attribute}", $attribute_value).exist?
     $testStatus = 'Passed'
     $totalPassed += 1  #increment total passed tests # by 1
     $passName = $testName
     puts testName + ' - Passed'
     writeTestResults(testName, element)
  else  
     $totalFailed += 1  #increment total failed tests # by 1
     $failureName = $failureName + '<tr><td style="background: red"><strong>' + testName + '</strong></td><td style="background: red"></td></tr>'
     $testStatus = 'Failed'
     puts testName + ' - Failed'
     writeTestResults(testName, element)
  end
end

def mcs_text_assertion_second_browser(testName,assertion)
   testName = testName
   assertion = assertion
   $totalTests += 1   #increment total tests # by 1
   if $browser2.html.include? assertion
     $testStatus = 'Passed'
     $totalPassed += 1  #increment total passed tests # by 1
     puts testName + ' - Passed'
     writeTestResults(testName, assertion)
  else  
     $totalFailed += 1  #increment total failed tests # by 1
     $testStatus = 'Failed'
     puts testName + ' - Failed'
     writeTestResults(testName, assertion)
  end
end

def mcs_second_browser_logout()
  $browser2.span(:id, 'userAccountName').when_present.click
  $browser2.link(:text, 'Sign Out').when_present.click
  $browser2.wait()
  mcs_text_assertion_second_browser('Logout from Second Browser',"Login")
end

def ci_ScreenCapture(assertionName)
  if ($app == 'MB' || ($app == 'WS' && $browser_type == 'chrome'))
    $screenCaptureImageFileName = $os + '-' + $app + '-' + $browser_type + '-' + assertionName + '-' + Time.new.strftime("%Y-%m-%d_%H%M%S") + '.png'
    $browser.screenshot.save Dir.pwd + '/output/screenshots/' + $screenCaptureImageFileName  
  end 
end

#Common Method for teardown. Pass "app' name as arguement.
def TearDown(app)
  #Get app name from abbreviations
  case app
  when 'MB'
    app = 'mcs'
  when 'WS'
    app = 'ws'
  end
  
  #Logout from app
  logout = "#{app}_Logout"
  send logout
  #~ #close first browser
  begin
    if $browser.exists?
      $browser.close
    end
  ensure
    $browser.close
  end
 
#~ #write result summary
  writeSummaryAndOverview()
  writeTestResultHtmlFooter()
end

# Set browser & os
def set_browser_os()
    browsers = Array['chrome']
    $os = 'Mac'
    if (RUBY_PLATFORM =~ /w32/) # windows
     $os = 'Windows'
     browsers = Array['chrome']
    elsif (RUBY_PLATFORM =~ /darwin/) # mac
     $os = 'Mac'
     browsers = Array['chrome','safari']
    end
end