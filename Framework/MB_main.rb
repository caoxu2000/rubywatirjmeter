$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
require "suites/mb_suites.rb"
require "helpers/readExcel.rb"
############################### UNDER HERE PUT IN WHAT YOUR TESTING: ###########################
########################## Note: Grab a test suite from suites>suites.rb #######################

#### MB UI test suites ######

cleanUpLastRunFilesAndFolders()
$os = 'Mac'
$browser_type = 'chrome'
suiteSmokeTest()
# suiteAmitDebug()
# suiteXuDebug()





