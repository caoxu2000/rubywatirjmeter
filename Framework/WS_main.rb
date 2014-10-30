$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
require "suites/ws_suites.rb"

############################### UNDER HERE PUT IN WHAT YOUR TESTING: ###########################
########################## Note: Grab a test suite from suites>suites.rb #######################

#### WS UI test suites ######
cleanUpLastRunFilesAndFolders()
browsers = Array['safari']
$os = 'Mac'
# browsers = set_browser_os()
browsers.each { | browser | ws_smoke(browser) }
# browsers.each { | browser | ws_Team_TestSuite(browser) }




