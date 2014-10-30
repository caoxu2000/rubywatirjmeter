require "helpers/setup.rb"
require "methods/mb_methods.rb"
require 'rubygems'
require 'watir-webdriver'
require 'watirgrid'

def suiteSmokeTest() # Smoke Test suite
  app = 'MB'
  env = 'Prod' 
  testHomePageButtonsBatch(app, env)
  testAdminPanelBatch(app, env)
  testAssetDetailBatch(app, env)
  testPreviewModalBatch(app, env)
  testFolderBatch(app, env)
  testEmailExportBatch(app, env)
end

def testHomePageButtonsBatch(app, env)
  ci_Setup(app, env)
  mcs_Login($userName, $password)
  mcs_HomePageButtons_Favorite()
  mcs_HomePageButtons_DownloadAspera()
  mcs_HomePageButtons_DownloadBasicHTTP()
  mcs_HomePageButtons_ProxyDownload()
  mcs_HomePageButtons_DeleteAsset()
  # mcs_HomePageButtons_ShareToFolder() # for some reason webdriver can not click on the share to folder icon.  comment it out for further investigation
  mcs_HomePageButtons_Details()
  mcs_HomePageButtons_RemoveFromFolder()
  mcs_OpenInCFP()
  mcs_Share()
  mcs_Apps_VideoReview()
  TearDown(app)
end

def testAdminPanelBatch(app, env)
  ci_Setup(app, env)
  name = 'caoxu2000@gmail.com'
  pwd = 'pa55w0rd'
  mcs_Login($userName, $password)
  mcs_AdminPanel_CreateNewAdminUser()
  mcs_AdminPanel_RestoreAssets_RecycleBin()
  # mcs_AdminPanel_PurgeAssets_RecycleBin() #script error wait on further investigation
  # mcs_AdminPanel_ManageTools_Edit() #issue won't be fixed
  mcs_AdminPanel_Privacy_AllowSonyAdmin()
  mcs_AdminPanel_ManageUserGroups_CreateNewGroup()
  # mcs_AdminPanel_ManageUserGroups_AddMemberToGroup() #script error wait on further investigation
  TearDown(app)  
end

def testAssetDetailBatch(app, env)
  ci_Setup(app, env)
  mcs_Login($userName, $password)
  # mcs_AssetDetail_AssetDescEdit()  # this test is not reliable. comment out until further investigation
  mcs_AssetDetail_OpenInCFP()
  mcs_AssetDetail_Preview()
  mcs_AssetDetail_AddtoFavorites()
  mcs_AssetDetail_RegularDownload()
  mcs_AssetDetail_HighSpeedDownload()
  mcs_AssetDetail_DeleteAsset()
  mcs_AssetDetail_MetaData()
  TearDown(app)   
end

def testPreviewModalBatch(app, env)
  ci_Setup(app, env)
  mcs_Login($userName, $password)
  mcs_PreviewModal_Share()
  mcs_PreviewModal_OpenInCFP()
  mcs_PreviewModal_RegularDownload()
  mcs_PreviewModal_HighSpeedDownload()
  # mcs_PreviewModal_Favorite()  ##because of the performance of the QA env, could not get the timing right. comment it out until speed improves
  TearDown(app) 
end

def testFolderBatch(app, env)
  ci_Setup(app, env)
  mcs_Login($userName, $password)
  # mcs_HomePage_CreateNewSubFolder()
  mcs_Follow_UnFollow_Folder()
  # mcs_Folder_Add_User_Permission()  # comment out since this still has issues.  need to debug more
  TearDown(app)  
end

def testEmailExportBatch(app, env)
  ci_Setup(app, env)
  mcs_FooterLinksBeforeLogin()
  mcs_Login($userName, $password)
  mcs_HeaderHelpLinksAfterLogin()
  mcs_EmailExport_AllowDownloadRequireLogin()
  mcs_EmailExport_UncheckAllowDownload()
  mcs_EmailExport_UncheckRequireLogin()
  TearDown(app)  
end

def suiteXuDebug()
  app = 'MB'
  env = 'Stage' 
  testAdminPanelBatch(app, env)
end

def suiteAmitDebug(browser)
  #the below $browser-type is the browser type in text
  $browser_type = browser
  #the below $browser will become an broswer object 
  $browser = browser
  app = 'MB'
  env = 'Prod' 
  ci_Setup('MB', 'Prod')
  mcs_invalid_login($wronguserName, $wrongpassword)
  mcs_Login($userName, $password)
  mcs_start_second_browser()
  mcs_Login_second_browser($userName, $password)
  mcs_session_out_first_browser()
  mcs_Amit_TearDown()
  mcs_login_logout(env,$userName, $password)
  mcs_launch_account(env,$userName, $password)
  TearDown(app)
end

def cleanUpLastRunFilesAndFolders()
  #Delete last run test results files
  File.delete("output/TestResults.htm") if File::exists?("output/TestResults.htm")
  #Delete last run screenshots folder
  if File::exists?("output/screenshots")
    if Dir["output/screenshots/*"] != nil
      FileUtils.rm_rf Dir.glob("output/screenshots/*")
    end
  end
  Dir.delete("output/screenshots") if File::exists?("output/screenshots")
  #Re-create the screenshots folder
  Dir.mkdir("output/screenshots") if !File::exists?("output/screenshots")
end

### grid code and it's in the dev branch.  will be removed someday from here ####
# def suiteWatirgridExperiment() # watirgrid experiment suite
  # Watir::Grid.control(:controller_uri => 'druby://172.23.41.13:11235') do |browser, id|
    # ci_Setup('WS', 'Dev')
    # $browser = browser
    # $browser.goto $envURL
    # $browser.window.move_to(0, 0)
    # $browser.window.resize_to(1600, 1200)
    # #mcs_Login($userName, $password)
    # ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')
    # # develop and debug individual test method here
    # # ws_Video_Review()
    # ws_TearDown()
  # end
# end

##### old deprecated methods and will be removed someday from here #####
# def suiteMyAccount() # Tests User Accounts page
  # ci_Setup('MB', 'QA')
  # mcs_Login($userName, $password)
  # mcs_2faLogin()
  # mcs_terms()
  # mcs_MyAccountProfile()
  # mcs_MyAccountProfileRegisteredDevices()
  # mcs_MyAccountProfileUpdatePassword()
  # mcs_TearDown()
# end
# 
# def suiteFileUpload() # Tests the File Upload page
  # ci_Setup('MB', 'QA')
  # mcs_Login($userName, $password)
  # mcs_2faLogin()
  # mcs_terms()
  # mcs_uploadAssets()
  # mcs_TearDown()
# end
# 
# def suiteResetPassword() # Tests the password reset
  # ci_Setup('MB', 'QA')
  # mcs_forgotPassword()
  # mcs_TearDown()
# end
# ##api test####
# def suiteCallApis() # Tests the API's
  # call_apis()
# end