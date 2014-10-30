require "helpers/setup.rb"
require "methods/ws_methods.rb"
require 'rubygems'
require 'watir-webdriver'
require 'watirgrid'

def ws_smoke(browser) # Ci Workspace smoke test suite
  #the below $browser-type is the browser type in text
  $browser_type = browser
  #the below $browser will become an broswer object 
  # this is how to clean browser cache: $browser.cookies.clear
  $browser = browser
  $isTestingTeamsite = true
  ci_Setup('WS', 'QA')
  ws_ForgotPasswordWithInvalidEmail('invalidEmail@qadotcom')
  ws_ForgotPasswordWithValidEmail('setpwd@yopmail.com')
  ws_ReturnToFrontPageUsingCiLogoFromLoginScreen()
  ws_ReturnToFrontPageUsingCiLogoFromSignUpScreen()
  ws_FailedLogin('setpwd@mailinator.com', 'passw0rd')
  ws_Login('setpwd@mailinator.com', 'pa55w0rd')
 # ws_FileAndStorageUsage()
  #ws_ChangePassword()
  ws_Logout()
  ws_DuplicateExistingSignUp()
  ws_ValidationAcceptTermsOfUse()
  ws_SignUp()
  ws_Logout()
  ws_BackLinkInWizardTutorial()
  ws_Logout()
  ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')
  # ws_VerifyUserNameHeader()
  # ws_VerifyAccountManagerPage()
  # ws_VerifyHelpHeader()
  # ws_ConnectedDeviceEditDeviceNameUnderWorkspace()
  # ws_WirelessAdapterClientPreviewOnUpload()
  # ws_WirelessAdapterEditDeviceNameUnderAccountManager()
  # ws_WirelessAdapterUnlinkDevice()
  ws_CloudDownloading()
  ws_Share()
  ws_ShareWithMultipleRecipients()
  ws_PreviewModalMetaDataTab()
  ws_PreviewModalSingleAssetShare()
  ws_PreviewModalMultiAssetsShare()
  ws_PreviewModalDownload()
  ws_PreviewModalStarUnstar()
  ws_Starring()
  ws_Trash_And_Restore()
  ws_CreateNewFolderUnderWorkspace()
  ws_Audio_Review_Add_Participants()
  ws_Audio_Review_SessionName()
  ws_Audio_Review_RelatedSession()
  ws_Video_Review_Add_Participants()
  ws_Video_Review_SessionName()
  ws_Video_Review_RelatedSession()
  ws_RoughCut_SessionName()
  ws_RoughCut_RelatedSession()
  if ($browser_type != 'safari')
    ws_Logout()
    ws_VerifyFooterLinks()
    ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')
    ws_Audio_Review_StartANewSession() #Todo item for mac safari: click on start new session link results in going back to workingspace in safari
    ws_Video_Review_StartANewSession() #Todo item for mac safari: click on start new session link results in going back to workingspace in safari
    ws_RoughCut_StartANewSession() #Todo item for mac safari: click on start new session link results in going back to workingspace in safari
    ws_Upload() #Todo item for mac safari: selected-files element not visible in safari for webdriver
    ws_RecentUpload('pic001.png')
    ws_VerifyPreviewModel('pic001.png')
  end
  ws_RetrieveShareLink()
  ws_Logout()
  ws_TearDown()
end  

def suiteFileInfoPreviewModal(browser)
  fileTypeArray = [
  ['robodog.avi',120,'avi','26 MB',''],
  ['reaccion.wav',240,'wav','3 MB',''],
  ['likeawave.mp3',30,'mp3','52 KB',''],
  ['spiderman.mov',240,'mov','892 KB','320x216'], 
  ['mess.mts',240,'mts','30 MB','1920x1080'], 
  ['ipod.wmv',240,'wmv','2 MB','360x264'],
  ['Brazil.png',120,'png','45 KB','256x256'],
  ['mark.mp4',240,'mp4','287 KB','640x480'],
  ['storm.jpg',180,'jpg','1 MB','2880x1800'],
  ['xdcamdv-ntsc.mxf',240,'mxf','8 MB','720x480']
  ]
  $browser_type = browser
  $browser = browser
  ci_Setup('WS', 'QA')
  ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')
  # ws_PreviewModalMetaDataImageFileType()
  if ($browser_type != 'safari')
    fileTypeArray.each do | eachFileType |
      ws_FileInfoOnPreviewModal(eachFileType[0], eachFileType[1], eachFileType[2], eachFileType[3], eachFileType[4])
    end
  end
  ws_Logout()
  ws_TearDown()
end

def ws_Team_TestSuite(browser) # Xu's test suite
  $isTestingTeamsite = true
  cc_no = '4444444444444448'  # this can be extracted out to a yml or excel with all the credit card numbers
  cc_cvv = '123'
  cc_exp_yyyy = '2026'
  bill_zip = '90064'
  cc_cvv_invalid = '12345'
  cc_no_less_than_16_digits = '123456789012345'
  cc_no_invalid = '4444444444444444'
  $browser_type = browser
  $browser = browser
  link_to_upgrade_to_plus_plan = '/html/body/div[5]/div/div/div/div/div/div[2]/div/a'
  link_to_upgrade_to_pro_plan = '/html/body/div[5]/div/div/div[2]/div[1]/div[3]/div/a'
  link_to_downgrade_to_basic_from_plus = '/html/body/div[5]/div/div/div/div/div/div[1]/div/a'
  link_to_downgrade_to_basic_from_pro = '/html/body/div[5]/div/div/div/div/div/div[1]/div/a'
  link_to_downgrade_to_plus_from_pro = '/html/body/div[5]/div/div/div/div/div/div[2]/div/a'
  upgrade_to_plus = 'Plus'
  upgrade_to_pro = 'Pro'
  create_250G_team_link = '/manage/payment?code=team-0'
  create_500G_team_link = '/manage/payment?code=team-1'
  create_1T_team_link = '/manage/payment?code=team-2'
  create_250GB_team_workspace_plan = '250GB'
  create_500GB_team_workspace_plan = '500GB'
  create_1TB_team_workspace_plan = '1TB'
  team_250GB_spec = 'Team - Small 25 GB'
  team_500GB_spec = 'Team - Medium 100 GB'
  team_1T_spec = 'Team - Large 1000 GB'
  team_name = 'Specific UI Weirdness found in Teams'
  tag_participant = 'PRODUCER'
  network_name = "Mark's Network"
  ci_Setup('WS', 'QA')
  $wsHome = $envHome
  ws_SignUp()
  # ws_Login('setpwd@mailinator.com', 'pa55w0rd')   
  # ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')

  # ws_VerifyDashboard(team_name, tag_participant, network_name)
  # upgrade to Plus from Basic
  ws_UpgradeFromBasicPlan(cc_no, true, cc_cvv, cc_exp_yyyy, bill_zip, link_to_upgrade_to_plus_plan, upgrade_to_plus, link_to_downgrade_to_basic_from_plus)
  # upgrade to Pro from Basic
  # ws_UpgradeFromBasicPlan(cc_no, true, cc_cvv, cc_exp_yyyy, bill_zip, link_to_upgrade_to_pro_plan, upgrade_to_pro, link_to_downgrade_to_basic_from_pro)
  
  # below are negative tests for personal plans
  # ws_UpgradeFromBasicPlan(cc_no, true, cc_cvv_invalid, cc_exp_yyyy, bill_zip, link_to_upgrade_to_plus_plan, upgrade_to_plus, link_to_downgrade_to_basic_from_plus)  #with invalid cc_cvv
  # ws_UpgradeFromBasicPlan(cc_no_less_than_16_digits, false, cc_cvv, cc_exp_yyyy, bill_zip, link_to_upgrade_to_plus_plan, upgrade_to_plus, link_to_downgrade_to_basic_from_plus) #with incorrect length of cc number
  # ws_UpgradeFromBasicPlan(cc_no_invalid, false, cc_cvv, cc_exp_yyyy, bill_zip, link_to_upgrade_to_plus_plan, upgrade_to_plus, link_to_downgrade_to_basic_from_plus)

  # Purchase Team Plans
  # ws_CreateTeamWorkspace(cc_no, cc_cvv, cc_exp_yyyy, bill_zip, create_250G_team_link, create_250GB_team_workspace_plan, team_250GB_spec)
  # ws_CreateTeamWorkspace(cc_no, cc_cvv, cc_exp_yyyy, bill_zip, create_500G_team_link, create_500GB_team_workspace_plan)
  # ws_CreateTeamWorkspace(cc_no, cc_cvv, cc_exp_yyyy, bill_zip, create_1T_team_link, create_1TB_team_workspace_plan)
  $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').wait_until_present
  $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
  $browser.link(:text, 'Logout').wait_until_present
  $browser.link(:text, 'Logout').when_present.click
  $browser.img(:alt, 'Ci').wait_until_present
  $browser.img(:alt, 'Ci').when_present.click
  # aria_Login('sonymcs2', 'sonymcs1', acctUserID, upgrade_to_plus)
  # acctUserID = ws_UpgradeFromBasicPlan(cc_no, true, cc_cvv, cc_exp_yyyy, bill_zip, link_to_upgrade_to_plus_plan, upgrade_to_plus, link_to_downgrade_to_basic_from_plus)  #with correct length of cc number 
  ws_TearDown()
end

def suiteWatirgridExperiment() # watirgrid experiment suite
  Watir::Grid.control(:controller_uri => 'druby://172.23.41.13:11235') do |browser, id|
    ci_Setup('WS', 'Dev')
    $browser = browser
    $browser.goto $envURL
    $browser.window.move_to(0, 0)
    $browser.window.resize_to(1600, 1200)
    #mcs_Login($userName, $password)
    ws_Login('xu_cao@spe.sony.com', 'pa55w0rd')
    # develop and debug individual test method here
    # ws_Video_Review()
    ws_TearDown()
  end
end

def ws_suiteAmitDebug(browser)
  $browser_type = browser
  #the below $browser will become an broswer object 
  $browser = browser
  app = 'WS'
  env = 'Prod' 
  ci_Setup(app, env)
  ws_Login('setpwd@mailinator.com', 'pa55w0rd')
  ws_VerifyUserNameHeader
  ws_VerifyAccountManagerPage
  ws_VerifyHelpHeader
  if ($browser_type != 'safari')
    ws_RecentUpload('pic001.png')
    ws_VerifyPreviewModel('pic001.png')
  end
  ws_TearDown()
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