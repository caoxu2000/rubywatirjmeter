require 'rubygems'
require 'active_support/secure_random'
require "helpers/readExcel.rb"
require "templates/blueGreen/template.rb"

# def run_apis() # Runs the API tests, No UI launched
  # apiReadExcel()
# end

def returnHomePage() # Returnd the user to the home page
  $browser.goto $envHome
end

def clickOnCiLogoToGoHomePage()
  $browser.link(:class, 'logo').when_present.click
end

######## MCS MB - Mediabox Tests begin ########

def mcs_FooterLinksBeforeLogin()
  begin
    ci_ScreenCapture('FooterLinksBeforeLogin')
    mcs_assertion('Help', 'MB Footer Links Before Login Help Link Presents Test', 'link', 'text', 'Help')
    mcs_assertion('Terms of Use', 'MB Footer Links Before Login Terms of Use Link Presents Test', 'link', 'text', 'Terms of Use')
    mcs_assertion('Privacy Policy', 'MB Footer Links Before Login Privacy Policy Link Presents Test', 'link', 'text', 'Privacy Policy')
    mcs_assertion('Acceptable Use', 'MB Footer Links Before Login Acceptable Use Link Presents Test', 'link', 'text', 'Acceptable Use')
    mcs_assertion('2013 Sony Media Cloud Services. All rights reserved.', 'MB Footer CopyRight Text Test', 'div', 'class', 'copyright')
    $browser.link(:text, 'Help').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSCustomerServiceHomePage')
    mcs_assertion('Welcome to Sony MCS Customer Service!', 'MB Footer Help MCS Customer Service Home Page Text Test', 'h2', 'text', 'Welcome to Sony MCS Customer Service!')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'Terms of Use').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSTermsofUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS', 'MB Footer Terms & Conditions Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'Privacy Policy').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSPrivacyPolicyPage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES PRIVACY POLICY', 'MB Footer Privacy Policy Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES PRIVACY POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'Acceptable Use').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSAcceptableUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY', 'MB Footer Acceptable Use Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
  rescue
    ci_ScreenCapture('mcs_FooterLinksBeforeLogin')
    mcs_failed_increment("mcs_FooterLinksBeforeLogin")
    $browser.refresh()
  end   
end

def mcs_HeaderHelpLinksAfterLogin()
  begin
    ci_ScreenCapture('MCSHelpLinkPresentsOnHomePage')
    mcs_assertion('Help', 'MB Help Link Present on Home page Test', 'link', 'id', 'HelpLink')
    $browser.link(:id, 'HelpLink').when_present.click
    $browser.link(:href, 'https://support.cimediacloud.com').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSCustomerServiceHomePage')
    mcs_assertion('Welcome to Sony MCS Customer Service!', 'MB Help Links After Login MCS Customer Service Home Page Text Test', 'h2', 'text', 'Welcome to Sony MCS Customer Service!')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:id, 'HelpLink').when_present.click
    $browser.link(:text, 'About Ci').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSAboutCiPage')
    mcs_assertion('Media Cloud Services', 'MB Help Links After Login About Ci Text Test', 'div', 'class', 'mcs-text')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:id, 'HelpLink').when_present.click
    $browser.link(:text, 'Terms of Use').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSTermsofUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS', 'MB Help Links After Login Terms & Conditions Text Test', 'b', 'text', 'SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:id, 'HelpLink').when_present.click
    $browser.link(:text, 'Privacy Policy').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSPrivacyPolicyPage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES PRIVACY POLICY', 'MB Help Links After Login Privacy Policy Text Test', 'b', 'text', 'SONY MEDIA CLOUD SERVICES PRIVACY POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:id, 'HelpLink').when_present.click
    $browser.link(:text, 'Acceptable Use').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('MCSAcceptableUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY', 'MB Help Links After Login Acceptable Use Text Test', 'b', 'text', 'SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
  rescue
    ci_ScreenCapture('mcs_HeaderHelpLinksAfterLogin')
    mcs_failed_increment("mcs_HeaderHelpLinksAfterLogin")
    $browser.refresh()
  end   
end

def mcs_Login(username, password) # Logins a user from - logins.xlsx
  begin
    $browser.text_field(:id, "Email").when_present.set(username)
    $browser.text_field(:id, "Password").when_present.set(password)
    $browser.send_keys :enter
    $browser.wait()
    # Proceed if already logged in on other browser
    if $browser.html.include? "You currently have Ci open in another browser elsewhere"
    	puts "Already Login on Another Browser"
    	$browser.div(:class => 'boxshadow-black user-app').click
    end
    # below is to select Customer 12 Account64 in QA and MCS Engineering Team in Prod both are form[1] - first choice on the customer account list page
    $browser.div(:xpath, '//*[@id="body-container"]/form[1]/div').when_present.click
    # Folder: My Folder on the home page
    $browser.span(:class, 'currentFeed').wait_until_present
    ci_ScreenCapture("MBLoginTest")
    mcs_text_assertion('MB User Login Test', 'MediaBox')
  rescue
    ci_ScreenCapture("mcs_Login_Exception_Fail")
    mcs_failed_increment("mcs_Login")
    $browser.refresh()
  end 
end

def mcs_HomePage_CreateNewSubFolder() #Create a new folder # Need break-down mechanic for folder creation to delete after
  # begin
    new_folder_name = 'autotest' + "#{Time.now.to_i}"
    $browser.li(:title, 'My Folder').wait_until_present
    $browser.li(:title, 'My Folder').when_present.flash
    $browser.div(:class, 'dz-folder-link dz1').fire_event("onClick")
    $browser.link(:id, "mcs_folder_create_sub_folder").when_present.flash
    $browser.link(:id, "mcs_folder_create_sub_folder").when_present.click
    $browser.text_field(:id, 'mcs_folder_rename_value').when_present.set new_folder_name
    $browser.link(:id, 'mcs_folder_createrename_save').when_present.click
    sleep 15
    mcs_assertion(new_folder_name, 'New Folder Creation Test', 'div', 'class', 'mcs-folderpicker')
    $browser.refresh()
  # rescue
    # mcs_failed_increment("mcs_HomePage_CreateNewSubFolder")
    # $browser.refresh()
  # end
end

def mcs_HomePageButtons_Details() # click on the Details button on the home page and access the asset details
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click 
    $browser.div(:xpath, "//div[contains(@class,'info-icon info-icon-details-active')]").when_present.click 
    sleep 7
    mcs_assertion('Technical Metadata', 'Details button on the home page and access the asset details', 'h1', 'xpath', "//h1[contains(.,'Technical Metadata')]")
    returnHomePage()
    $browser.refresh()
  rescue
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Detail")
    $browser.refresh()
  end  
end

def mcs_HomePageButtons_AppsClickable() # click on the Apps button on the home page and access the apps modal
    begin
     $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click 
     $browser.div(:xpath, "//div[contains(@class,'info-icon info-icon-apps-active')]").when_present.click 
     mcs_assertion('Ci Review&Approve', 'HomePage Buttons - Click on an asset and then clink on the apps button', 'h3', 'text', 'Ci Review&Approve')
    rescue 
      mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Apps")
    end 
end

def mcs_HomePageButtons_Share()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-share-active').when_present.click
    mcs_assertion('1 Files / 21257718 B', 'HomePage Buttons - Click on an asset and then clink on the share button', 'span', 'id', 'assetExportSize')
    $browser.link(:id, 'acceptGenericModal').when_present.click
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Share")
  end   
end

def mcs_AssetDetail_MetaData() # access the asset detail page
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    $browser.h1(:text, 'Technical Metadata').wait_until_present
    mcs_assertion('Technical Metadata', 'Access Asset Detail Page', 'h1', 'text', 'Technical Metadata')
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_AssetDetailPage")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end   
end

def mcs_AssetDetail_AssetDescEdit() # access the asset detail page
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    sleep 7
    $browser.div(:class, 'det-desc').when_present.click
    $browser.text_field(:id, 'det-desc-input').when_present.set 'Asset Description entered by automation'
    $browser.div(:id, 'myMetadata1').when_present.click
    sleep 7 
    mcs_assertion('Asset Description entered by automation', 'Asset Detail Page Asset Description Editing', 'div', 'class', 'det-desc')
    #need to wipe the test out for the next test.  so it's kind of tear down for the current test
    $browser.div(:class, 'det-desc').when_present.click
    $browser.text_field(:id, 'det-desc-input').when_present.set ''
    $browser.div(:id, 'myMetadata1').when_present.click
    sleep 7
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_HomePageAssetDetailLink_EditAssetDescription_AssetDetailPage")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end   
end

def mcs_AssetDetail_OpenInCFP()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.link(:title, 'Open with App').when_present.click
    mcs_assertion('DjangoIntl TV.mov', 'Asset Detail page Action Menu OpenInCFP asset name test', 'div', 'class', 'title')
    mcs_assertion('Ci VideoReview', 'Asset Detail page Action Menu OpenInCFP Ci VideoReview test', 'h3', 'text', 'Ci VideoReview')
    $browser.i(:class, 'mcs-lightgray-remove').when_present.click
    sleep 3
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_OpenInCFP")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetail_Preview()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.link(:title, 'Preview').when_present.click
    mcs_assertion('', 'Preview Modal under Action menu on Asset Detail Page', 'div', 'id', 'inlinePreview_wrapper') 
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_Preview")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetail_AddtoFavorites()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.link(:title, 'Add to Favorites').when_present.click
    mcs_assertion('Asset DjangoIntl TV.mov has been added to your Favorites', 'Add to Favorite under Action menu on Asset Detail Page', 'div', 'id', 'genericModalBody') 
    $browser.link(:id, 'acceptGenericModal').when_present.click
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_AddtoFavorites")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetail_RegularDownload()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    mcs_assertion('Regular Download', 'Regular Download Action menu on Asset Detail Page', 'li', 'text', 'Regular Download') 
    $browser.li(:text, 'Regular Download').when_present.click
    sleep 10
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_RegularDownload")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetail_HighSpeedDownload()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    mcs_assertion('High-Speed Download', 'High-Speed Download Action menu on Asset Detail Page', 'li', 'text', 'High-Speed Download') 
    $browser.li(:text, 'High-Speed Download').when_present.click
    mcs_assertion('We have started your high-speed download using Aspera Connect.', 'High-Speed Download Confirmation Popup test on Asset Detail Page', 'div', 'id', 'genericModalBody')
    sleep 10
    clickOnCiLogoToGoHomePage()
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_HighSpeedDownload")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetail_AdvanceProxyDownload()
  begin
    $browser.link(:xpath, "//a[contains(@title,'DjangoIntl TV.mov')]").when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.li(:text, 'Advance Download').when_present.click
    mcs_assertion('Asset Elements', 'Advance Proxy Download on Asset Detail page', 'h1', 'text', 'Asset Elements')
    $browser.link(:id, 'backbutton').when_present.click
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_AdvanceProxyDownload")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end  
end

def mcs_AssetDetail_ShareViaEmail()
  begin
    $browser.link(:xpath, "//a[contains(@title,'DjangoIntl TV.mov')]").when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.li(:text, 'Share via Email').when_present.click
    mcs_assertion('SHARE', 'Share Via Email on Asset Detail page', 'h3', 'text', 'SHARE')
    $browser.refresh()
    $browser.link(:class, 'logo').when_present.click
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_ShareViaEmail")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end 
end

def mcs_AssetDetail_DeleteAsset()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-details-active').when_present.click
    #below is to click on the action menu on top right corner of the preview thumb panel
    $browser.div(:xpath, "//div[contains(@data-name,'DjangoIntl TV.mov')]").when_present.click
    $browser.li(:text, 'Delete Asset').when_present.click
    mcs_assertion('Are you sure you want to delete', 'Delete Asset Confirmation Popup on Asset Detail page', 'div', 'id', 'genericConfirmationModalBody')
    $browser.link(:id, 'declineGenericConfirmationModal').when_present.click
    $browser.element(:xpath, "//a[contains(@class,'logo')]").wait_until_present
    $browser.element(:xpath, "//a[contains(@class,'logo')]").when_present.click
  rescue 
    mcs_failed_increment("mcs_AssetDetailPage_ActionMenu_DeleteAsset")
    $browser.refresh()
    clickOnCiLogoToGoHomePage()
  end
end

def mcs_AssetDetailsAddVideoTag() # Adds a 'Video' tag to an asset
  $browser.link(:xpath, "//a[contains(@title,'DjangoIntl TV.mov')]").when_present.click # Need to remove hard-code
  $browser.button(:class, "mcs-SelectSearchDropDown")
  $browser.select_list(:name, "mcs-Video").when_present.select("mcs-Video")
  $browser.link(:class, "mcs-gray-remove").when_present.click
  if $browser.label.include? "MCS_Description"
    puts "Clear All Tags - Failed"
  else
    puts "Clear All Tags - Successful"
  end
  $browser.text_field(:class, "mcs-SelectSearchInput").when_present.set("mcs-Video")
  $browser.select_list(:name, "mcs-Video").when_present.select("mcs-Video")
  if $browser.label.include? "MCS_Description"
    puts "Label Added - Successful"
  else
    puts "Label Added - Failed"
  end
end

def mcs_AssetDetailsPutAssetInFolder() # Assigns an asset to a folder from the Asset Details page
  $browser.link(:value, "Black Keys.MOV").when_present.click
  $browser.link(:class, "mcs-assetDetailFolders").when_present.click # Bug 3547, The 'Put in Folder' link from the Asset Details page is not working
end

def mcs_SearchAsset() # Revised and works
  $browser.text_field(:class, "as-input").when_present.set("BOOM")
  $browser.send_keys :enter
  sleep 3
  ci_ScreenCapture("SearchAssetResultsPageOneTest")
  mcs_assertion('Search Results', 'Ci MB Search Results Title Text Test', 'h2', 'class', 'mcs-heading-title')
  mcs_assertion('Search Criteria', 'Ci MB Search Criteria Title Text Test', 'div', 'class', 'searchedForTitleText')
  mcs_assertion('Asset Types', 'Ci MB Search Asset Type Filter Text Test', 'h3', 'text', 'Asset Types')
  mcs_assertion('Approval Status', 'Ci MB Search Approval Status Text Test', 'h3', 'text', 'Approval Status')
  mcs_assertion('Video', 'Ci MB Search Filter Asset Type Video Test', 'p', 'class','filterName')
  mcs_assertion('(11)', 'Ci MB Search Filter Video Asset Type Count Test', 'p', 'xpath', '//*[@id="filters"]/div[1]/ul/li[1]/p[2]')
  mcs_assertElementPresent('Ci MB Search Results Showing 12 assets per page if total results are more than 12', 'div', 'xpath', '//*[@id="thumbResults"]/div[12]')
  mcs_assertion('Result(s)', 'Search Assets', 'span', 'class', 'resultCount')
  #search keyword filter
  mcs_assertion('"BOOM"', 'Ci MB Search Keyword Filter Test', 'span', 'text', '"BOOM"')
  for i in 1..5
    $browser.div(:id, 'searchPaging').span(:class, 'nextPage mcs-darkgray-arrow-right').when_present.click
    sleep 3
  end
  ci_ScreenCapture("SearchAssetResultsPageSixTest")
  mcs_assertElementPresent('Ci MB Search Results Showing 5 assets on last page if total results are 65', 'div', 'xpath', '//*[@id="thumbResults"]/div[5]')
  $browser.p(:text, 'Video').when_present.click
  sleep 3
  ci_ScreenCapture("SearchCriteriaAssetTypeResultsTest")
  mcs_assertion('11', 'Ci MB Search Video Keyword and Video Asset Type Criteria Test', 'span', 'class', 'resultCountNumber')
  $browser.link(:class, 'logo').when_present.click
end

def mcs_SavedItems() # tests the Saved Items Page
  sleep 2
  $browser.text_field(:class, "as-input").when_present.set("BOOM")
  $browser.send_keys :enter
  $browser.send_keys :enter
  Watir::Wait.until { $browser.text.include? "Result(s)" }
  if $browser.text.include? "Result(s)"
    puts "Asset Search - Successful"
  else
    puts "Asset Search - Failed"
  end
  sleep 2
  $browser.link(:text, "Select All").when_present.click # Issue with SELECT ALL (Neew research on this)
  $browser.link(:id, "multiSelectDropdown").when_present.click
  $browser.link(:text, "Add to Saved Items").when_present.click
  puts "Add to Saved Items - Successful"
  sleep 2
  $browser.link(:text, "Saved Items ").when_present.click
  puts "Saved Items - Successful"
end

def mcs_MyAccountProfileUpdatePassword() # Bug: Password doesn't get updated
  $browser.link(:text, "My Account").when_present.click
  $browser.h5(:id, "passwordEdit").when_present.click
  $browser.text_field(:id, "oldPassword").when_present.set($password)
  $browser.text_field(:id, "newPassword").when_present.set($password)
  $browser.text_field(:id, "confirmPassword").when_present.set($password)
  $browser.text_field(:id, "newPassword").when_present.set($password) #//Bug: The Save button doesn't get enabled unless you click other text fields. 
  $browser.button(:id, "savePassword").when_present.click
  if $browser.div(:text, "Your password has been update successfully.").when_present.text
    puts "Password Update - Successful"
  else
    puts "Password Update - Failed"
  end 
end  

def mcs_MyAccountProfile() # Tests My accounts > Profile
  $browser.link(:id, "MyaccountLink").when_present.click
  mcs_assertion('Admin', 'Admin Drop-down', 'link', 'text', 'Admin')
  mcs_assertion('My Account', 'My Account Drop-down', 'link', 'text', 'My Account')
  $browser.link(:text, "My Account").when_present.click
  mcs_assertion('User Preferences', 'My Account User Preferences Drop-down', 'h2', 'text', 'User Preferences')
  $browser.div(:id, "basicInfoEdit").when_present.click
  $browser.text_field(:id, "firstName").when_present.set("#{$firstName} Edited")
  $browser.text_field(:id, "lastName").when_present.set("#{$lastName} Edited")
  #Todo need to grad the selected value to verify it's been selected and saved
  #$browser.select_list(:id, "countries").when_present.select("United Kingdom")
  $browser.send_keys :enter
  $browser.link(:id, "saveBasicInfo").when_present.click
  $browser.goto $envHome
  $browser.link(:id, "MyaccountLink").when_present.click
  $browser.link(:text, "My Account").when_present.click
  $browser.div(:id, "basicInfoEdit").when_present.click
  mcs_text_assertion('User First Name Update', "#{$firstName} Edited")
  mcs_text_assertion('User Last Name Update', "#{$lastName} Edited")
  mcs_text_assertion('User Country Update', "United Kingdom")
end
  
def mcs_MyAccountProfileRegisteredDevices() # Need to add and delete device verifications - BUG: can't add device
  $browser.link(:text, "My Account").when_present.click
  $browser.h5(:id, "registeredDevicesEdit").when_present.click
  $browser.text_field(:value, "Work").when_present.append(" - QA")
  $browser.text_field(:value, "Home Phone").when_present.append(" - QA")
  $browser.text_field(:value, "Office").when_present.append(" - QA")
  $browser.text_field(:value, "Center Phone 2").when_present.append(" - QA")
  $browser.radio(:id, "radio-3").when_present.set
  $browser.button(:id, "saveRegisterDevices").when_present.click
  $browser.span(:id, "registeredDevicesCollpaseExpanse").when_present.click
  if $browser.text.include? " - QA"
    puts "Registered Devices Names Update - Successful"
  else
    puts "Registered Devices Names Update - Failed"
  end
end
  
def mcs_uploadAssets() # Tests the Upload Asset feature
  $browser.div(:onclick => "uploadFile()").when_present.click
  sleep 2
  $browser.div(:text => "Files").when_present.click
  sleep 2
  puts "here 2"
  #$browser.div(:xpath, "//div[@class='uploadFiles']").when_present.click
  $browser.file_field(:index, 1).set("/Users/sonyit/Desktop/test.png")
  puts "here 3"  
end

def mcs_Help() #Help Page
  Watir::Wait.until { $browser.div(:id, 'assethome_my_assets').text.include? 'My Assets' }
  $browser.link(:href, "https://support.cimediacloud.com").when_present.click
  mcs_assertion('Welcome to the Sony MCS Customer Service!', 'Help Page', 'div', 'class', 'introductory_display_texts')
end

def mcs_OpenInCFP()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-apps-active').when_present.click
    $browser.h3(:text, 'Ci VideoReview').wait_until_present
    mcs_assertion('BOOM_Premiere', 'App button Asset File Name text test', 'div', 'class', 'title')
    mcs_assertion('Ci VideoReview', 'Apps button Ci Review&Approve text test', 'h3', 'text', 'Ci VideoReview')
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Apps")
    $browser.refresh()
  end  
end

def mcs_Apps_VideoReview()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").wait_until_present
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-apps-active').wait_until_present
    $browser.div(:class, 'info-icon info-icon-apps-active').when_present.click
    $browser.h3(:text, 'Ci VideoReview').wait_until_present
    $browser.h3(:text, 'Ci VideoReview').when_present.click
    $browser.windows.last.use
    mcs_assertion('Feedback', 'Feed back link presented on Video Review on cfpapps', 'a', 'class', 'header_link')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.refresh() 
  rescue 
    mcs_failed_increment("mcs_Apps_VideoReview")
    $browser.refresh()
  end
end

def mcs_Share()
  # begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-share-active').when_present.click
    $browser.h3(:text, 'SHARE').wait_until_present
    mcs_assertion('SHARE', 'Asset Email Share/Export', 'h3', 'text', 'SHARE')
    $browser.refresh()
  # rescue 
    # mcs_failed_increment("mcs_Share")
    # $browser.refresh()
  # end   
end

def mcs_HomePageButtons_Favorite()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-favorite-active').when_present.click
    mcs_assertion('has been added to your Favorites', 'Favorite action button', 'div', 'id', 'genericModalBody')
    $browser.link(:id, 'acceptGenericModal').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Favorite")
    $browser.refresh()
  end   
end

def mcs_HomePageButtons_DownloadAspera()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-download-active download-gray').when_present.click
    mcs_assertion('High-Speed Download', 'Download action button High-Speed option', 'li', 'text', 'High-Speed Download')
    $browser.li(:text, 'High-Speed Download').when_present.click
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Download_Aspera")
    $browser.refresh()
  end   
end

def mcs_HomePageButtons_DownloadBasicHTTP()
  begin
    $browser.link(:class, 'logo').when_present.click
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-download-active download-gray').when_present.click
    mcs_assertion('Regular Download', 'Download action button Basic HTTP option', 'li', 'text', 'Regular Download')
    $browser.li(:text, 'Regular Download').when_present.click
    sleep 20
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Download_Basic")
  end   
end

def mcs_HomePageButtons_ProxyDownload()
  begin
    $browser.link(:class, 'logo').when_present.click
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-download-proxy-active').when_present.click
    $browser.button(:text, 'Download').when_present.click
    mcs_assertion('Asset Elements', 'Asset Element Proxy Download Test', 'h1', 'text', 'Asset Elements')
    $browser.span(:class, 'caret').when_present.click
    $browser.link(:text, 'High-Speed Download').when_present.click
    $browser.link(:id, 'backbutton').when_present.click
  rescue 
    mcs_failed_increment("mcs_HomePageButtonsApps_clickable_Proxy")
    $browser.refresh()
  end   
end

def mcs_HomePageButtons_DeleteAsset()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-delete-active').when_present.click
    mcs_assertion('Please confirm you would like to delete', 'Delete action button', 'div', 'id', 'genericConfirmationModalBody')
    $browser.link(:id, 'declineGenericConfirmationModal').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_HomePageButtons_DeleteAsset")
    $browser.refresh()
  end   
end

def mcs_HomePageButtons_ShareToFolder()
  # begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").wait_until_present
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:id, "main-info-panel").div(:id, "info-icons").div(:class, "info-icon info-icon-publish-to-folder-active").wait_until_present
    $browser.div(:id, "main-info-panel").div(:id, "info-icons").div(:class, "info-icon info-icon-publish-to-folder-active").when_present.click
    $browser.h2(:text, "Put in Folder").wait_until_present
    mcs_assertion('Put in Folder', 'Share To Folder action button test', 'h2', 'text', 'Put in Folder')
    $browser.refresh()
  # rescue 
    # ci_ScreenCapture("mcs_HomePageButtons_ShareToFolder_Exception")
    # mcs_failed_increment("mcs_HomePageButtons_ShareToFolder_ShareToFolder")
    # $browser.refresh()
  # end   
end

def mcs_HomePageButtons_RemoveFromFolder()
  # begin
    $browser.div(:xpath, "//div[contains(@data-name,'THISISIT_Intl_WAY_6735_.jpg')]").wait_until_present
    $browser.div(:xpath, "//div[contains(@data-name,'THISISIT_Intl_WAY_6735_.jpg')]").when_present.click
    $browser.div(:id, "main-info-panel").div(:id, "info-icons").div(:class, 'info-icon info-icon-unpublish-from-folder-active').wait_until_present
    $browser.div(:id, "main-info-panel").div(:id, "info-icons").div(:class, 'info-icon info-icon-unpublish-from-folder-active').when_present.click
    mcs_assertion('Confirm Removal', 'Remove From Folder action button', 'h3', 'text', 'Confirm Removal')
    $browser.button(:xpath, "//button[contains(.,'Cancel')]").when_present.click
    $browser.refresh()
  # rescue 
    # mcs_failed_increment("mcs_HomePageButtons_RemoveFromFolder_RemoveToFolder_Exception")
    # $browser.refresh()
  # end   
end

def mcs_PreviewModal_Favorite()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.image(:xpath, "//img[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    sleep 25
    $browser.div(:class, 'inl-sprites inl-favorite').when_present.click
    #below is just to check the yellow star element exist or not.  so no text value is there that's why it's an empty text
    #this assertion doesn't work because the method has problem with 'Compound class names not permitted'
    #mcs_assertion('', 'Favorite On Preview Modal', 'div', 'class', 'inl-sprites inl-favorite-on')
    $browser.div(:class, 'inl-sprites inl-favorite-on').when_present.click
    mcs_assertion('', 'Favorite On Preview Modal', 'div', 'id', 'inlinePreview_wrapper') 
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_PreviewModal_Favorite")
  end 
end

def mcs_PreviewModal_Share()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.image(:xpath, "//img[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    #someone on the internet suggested to put a wait time here to make it work
    sleep 15
    $browser.div(:xpath, "//div[@title='Share']").when_present.click
    mcs_assertion('SHARE', 'Asset Email Share/Export on the Preview Modal', 'h3', 'text', 'SHARE')
    $browser.refresh()
    $browser.link(:class, 'logo').when_present.click
  rescue
    mcs_failed_increment("mcs_PreviewModal_Share")
    $browser.refresh()
  end   
end

def mcs_PreviewModal_OpenInCFP()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.image(:xpath, "//img[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    #someone on the internet suggested to put a wait time here to make it work
    sleep 10
    $browser.div(:xpath, "//div[@title='Open in Apps']").when_present.click
    mcs_assertion('Sizzle_v1_1920x1080-proxy-hi.mp4', 'App button Asset File Name text test on the Preview Modal', 'div', 'class', 'title')
    mcs_assertion('Ci VideoReview', 'Apps button Ci VideoReview text test on the Preview Modal', 'h3', 'text', 'Ci VideoReview')
    $browser.i(:class, 'mcs-lightgray-remove').when_present.click
    $browser.refresh()
  rescue
    mcs_failed_increment("mcs_PreviewModal_OpenInCFP")
    $browser.refresh()
  end  
end

def mcs_PreviewModal_RegularDownload()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.image(:xpath, "//img[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    #someone on the internet suggested to put a wait time here to make it work
    sleep 10
    $browser.div(:xpath, "//div[@title='Download']").when_present.click
    mcs_assertion('Regular Download', 'Download icon Regular Download option test on the Preview Modal', 'li', 'text', 'Regular Download')
    $browser.li(:text, 'Regular Download').when_present.click
    sleep 20
    $browser.refresh()  
  rescue
    mcs_failed_increment("mcs_PreviewModal_RegularDownload")
    $browser.refresh()
  end  
end

def mcs_PreviewModal_HighSpeedDownload()
  begin
    $browser.link(:class, 'logo').when_present.click
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.image(:xpath, "//img[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    #someone on the internet suggested to put a wait time here to make it work
    sleep 10
    $browser.div(:xpath, "//div[@title='Download']").when_present.click
    $browser.li(:text, 'High-Speed Download').when_present.click
    mcs_assertion('We have started your high-speed download using Aspera Connect.', 'Download icon High-Speed Download Aspera option test on the Preview Modal', 'div', 'id', 'genericModalBody')
    $browser.link(:id, 'acceptGenericModal').when_present.click
    sleep 20
    $browser.refresh() 
  rescue
    mcs_failed_increment("mcs_PreviewModal_HighSpeedDownload")
    $browser.refresh()
  end  
end

def mcs_EmailExport_AllowDownloadRequireLogin()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click 
    $browser.div(:class, 'info-icon info-icon-share-active').when_present.click
    $browser.text_field(:id,'EmailRecipients').when_present.set 'setpwd@yopmail.com'
    emailSubject = 'Allow Download Require Login Email Export from Ruby Automation Script ' + Time.new.inspect
    $browser.text_field(:id,'EmailSubject').when_present.set emailSubject
    $browser.text_field(:id,'EmailMessage').when_present.set emailSubject
    $browser.link(:id, 'assetExportSubmit').when_present.click
    mcs_assertion('We have sent your assets to get prepared, packaged and delivered via email!', 'Email export with all default checked', 'div', 'id','ShareLinkSection')
    $browser.link(:id,'assetExportClose').when_present.click
    $browser.refresh()
    # Todo: end to end to check share email in the inbox and click the link in the email
    # sleep 20 #wait 20 seconds for mcs sends email to yopmail
    # $browser.goto "www.yopmail.com/en/?setpwd"
    # $browser.frame(:id, 'ifmail').link(:xpath, "//a[contains(., 'Click here to get file(s)')]").when_present.click
    # $browser.windows.last.use
    # mcs_assertion(emailSubject, 'Allow Download Require Login Export email redirect', 'h5', 'text', emailSubject)
    # sleep 20  #waiting 20 secs to watch the preview video
  rescue 
    mcs_failed_increment("mcs_EmailExport_AllowDownloadRequireLogin")
    $browser.refresh()
  end   
end

def mcs_EmailExport_UncheckAllowDownload()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-share-active').when_present.click
    $browser.text_field(:id,'EmailRecipients').when_present.set 'setpwd@yopmail.com'
    emailSubject = 'Send Preview Only (not allow download) Email Export Test from Ruby Automation Script ' + Time.new.inspect
    $browser.text_field(:id,'EmailSubject').when_present.set emailSubject
    $browser.text_field(:id,'EmailMessage').when_present.set emailSubject
    $browser.checkbox(:id, 'SendPreviewNoTranscode').when_present.clear  # Uncheck Aloow download assets to essentially send preview only
    $browser.link(:id, 'assetExportSubmit').when_present.click
    mcs_assertion('We have sent your assets to get prepared, packaged and delivered via email!', 'Email export with sending preview only (uncheck allow download)', 'div', 'id','ShareLinkSection')
    $browser.link(:id,'assetExportClose').when_present.click
    $browser.refresh()
    # sleep 20  #wait 20 seconds for mcs sends email to yopmail
    # $browser.goto "www.yopmail.com/en/?setpwd"
    # $browser.frame(:id, 'ifmail').link(:xpath, "//a[contains(., 'Click here to get file(s)')]").when_present.click
    # $browser.windows.last.use
    # mcs_assertion(emailSubject, 'Send Preview Only (not allow download) Email Export Test', 'h5', 'text', emailSubject)
    # sleep 20  #waiting 20 secs to watch the preview video
  rescue 
    mcs_failed_increment("mcs_EmailExport_UncheckAllowDownload")
    $browser.refresh()
  end   
end

def mcs_EmailExport_UncheckRequireLogin()
  begin
    $browser.div(:xpath, "//div[contains(@data-name,'BOOM_Premiere  Sizzle_v1_1920x1080-proxy-hi.mp4')]").when_present.click
    $browser.div(:class, 'info-icon info-icon-share-active').when_present.click
    $browser.text_field(:id,'EmailRecipients').when_present.set 'setpwd@yopmail.com'
    emailSubject = 'Login Not Required Email Export Test from Ruby Automation Script ' + Time.new.inspect
    $browser.text_field(:id,'EmailSubject').when_present.set emailSubject
    $browser.text_field(:id,'EmailMessage').when_present.set emailSubject
    $browser.link(:class, 'dropdown-toggle export-checkbox mcs-color-info').when_present.click  #click on the video transcode option link
    $browser.link(:href, '#transcodeMP4').when_present.click  #click on the MP4
    $browser.input(:id, 'MP4_04').when_present.click  #select first radio option MPEG-4 HD - 18 Mbps
    $browser.checkbox(:id, 'IsLoginRequired').when_present.clear  #uncheck Require Log-in checkbox
    $browser.link(:id, 'assetExportSubmit').when_present.click
    mcs_assertion('We have sent your assets to get prepared, packaged and delivered via email!', 'Email export with Login Not Required', 'div', 'id','ShareLinkSection')
    $browser.link(:id,'assetExportClose').when_present.click
    $browser.refresh()
    # sleep 20 #wait 20 seconds for mcs sends email to yopmail
    # $browser.goto "www.yopmail.com/en/?setpwd"
    # $browser.frame(:id, 'ifmail').link(:xpath, "//a[contains(., 'Click here to get file(s)')]").when_present.click
    # $browser.windows.last.use
    # mcs_assertion(emailSubject, 'Login Not Required Email Export Test', 'h5', 'text', emailSubject)
    # sleep 20  #waiting 20 secs to watch the preview video
  rescue 
    mcs_failed_increment("mcs_EmailExport_UncheckRequireLogin_DownloadWithTranscodeOption")
    $browser.refresh()
  end   
end

def mcs_AdminPanel_CreateNewBasicUser()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id,'btnAddUser').when_present.click
    $browser.text_field(:id,'FirstName').when_present.set 'AutoTestFN'
    $browser.text_field(:id,'LastName').when_present.set 'AutoTestLN'
    randomUserAcct = 'AutoTest' + ActiveSupport::SecureRandom.hex(3)
    randomEmail = randomUserAcct + '@yopmail.com'
    $browser.text_field(:id,'Email').when_present.set randomEmail
    $browser.text_field(:id,'ConfirmEmail').when_present.set randomEmail
    $browser.button(:id,'updateUser').when_present.click
    sleep 20
    mcs_assertion('User creation successful.', 'New Basic User Creation', 'div', 'class', 'modal-message')
    $browser.button(:text,'Close').when_present.click
    sleep 5
    $browser.link(:class, 'logo').when_present.click
  rescue 
    mcs_failed_increment("mcs_AdminPanel_NewBasicUserCreation")
  end  
end

def mcs_AdminPanel_CreateNewAdminUser()
  begin
    randomEmail = 'AutoTest' + ActiveSupport::SecureRandom.hex(3) + '@yopmail.com'
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id, 'tabAddManageUsers').when_present.click
    $browser.div(:id,'btnAddUser').when_present.click
    $browser.text_field(:id,'FirstName').when_present.set 'AutoTestFN'
    $browser.text_field(:id,'LastName').when_present.set 'AutoTestLN'
    $browser.text_field(:id,'Department').when_present.set 'Automation Department'
    $browser.text_field(:name,'Territory').when_present.set 'United States'
    $browser.text_field(:id,'Email').when_present.set randomEmail
    $browser.input(:id, 'roleRadioAdministrator').when_present.click
    $browser.checkbox(:value, '865').set
    #framesync tool got removed in sprint 19-4
    #$browser.checkbox(:value, '864').set
    $browser.checkbox(:value, '863').set
    $browser.checkbox(:value, '862').set
    $browser.button(:id,'updateUser').when_present.click
    sleep 20
    $browser.div(:class, 'admin-edit-user-headername').wait_until_present
    mcs_assertion('Send Email Invitation', 'New Admin User Creation', 'div', 'class', 'admin-edit-user-headername')
    $browser.button(:id, 'sendInvitation').when_present.click
    mcs_assertion('Invitation sent successfully.', 'Invitation Email Sent Test', 'div', 'class', 'modal-message')
    $browser.button(:text,'Close').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_NewAdminUserCreation")
    $browser.refresh()
  end
end

def mcs_AdminPanel_ManageUserGroups_CreateNewGroup()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id, 'tabAddManageGroups').when_present.click
    $browser.div(:id, 'btnAddGroup').wait_until_present
    $browser.div(:id, 'btnAddGroup').when_present.click
    randomGroupName = 'AutoGroup ' + ActiveSupport::SecureRandom.hex(3)
    $browser.text_field(:id, 'GroupName').when_present.set randomGroupName
    randomGroupDesc = 'AutoGroupDesc ' + Time.new.inspect
    $browser.textarea(:id, 'GroupDescription').when_present.set randomGroupDesc
    $browser.button(:id, 'saveGroup').when_present.click
    $browser.text_field(:class, 'admin-manage-users-search').when_present.set randomGroupName
    $browser.link(:xpath, '//*[@id="admingroup-searchresults"]/div/div[2]/div/a').when_present.click
    mcs_assertion(randomGroupDesc, 'Create a new group test on Manage User Groups', 'textarea', 'id', 'GroupDescription')
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_ManageUserGroups_CreateNewGroup")
    $browser.refresh()
  end 
end

def mcs_AdminPanel_ManageUserGroups_AddMemberToGroup()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id, 'tabAddManageGroups').when_present.click
    $browser.div(:id, 'btnAddGroup').wait_until_present
    $browser.text_field(:id, 'txtAdminGroupSearch').when_present.set 'AutoGroup'
    $browser.link(:xpath, '//*[@id="admingroup-searchresults"]/div/div[3]/div/a').when_present.click
    $browser.div(:id, 'btnAddParticipant').when_present.click
    $browser.text_field(:id, 'txtAddParticipantSearch').when_present.set 'Xu'
    $browser.div(:xpath, '//*[@id="divAddParticipantsToGroup"]/div[11]/table/tbody/tr/td[2]/div[1]').when_present.click
    $browser.div(:xpath, '//*[@id="divAddParticipantsToGroup"]/div[13]/table/tbody/tr/td[2]/div[1]').when_present.click
    $browser.execute_script('javascript:document.elementFromPoint(0, 0).click();')
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div[1]/div[1]/div[1]').wait_until_present
    mcs_assertion('Xu Cao', 'Add 1st user to a group on Manage User Groups', 'div', 'xpath', '//*[@id="divAdminParticipants"]/div[1]/div[1]/div[1]')
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div[2]/div[1]/div[1]').wait_until_present
    mcs_assertion('Xu Cao', 'Add 2nd user to a group on Manage User Groups', 'div', 'xpath', '//*[@id="divAdminParticipants"]/div[2]/div[1]/div[1]')
    #below is to remove these 2 users off the group in order for the next test to be able to add them again
    #so it's a little teardown for this test
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div[1]/div[2]').wait_until_present
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div[1]/div[2]').when_present.click
    $browser.button(:text, 'Confirm').when_present.click
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div/div[2]').wait_until_present
    $browser.div(:xpath, '//*[@id="divAdminParticipants"]/div/div[2]').when_present.click
    $browser.button(:text, 'Confirm').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_ManageUserGroups_AddMemberToGroup")
    $browser.refresh()
  end  
end

def mcs_AdminPanel_RestoreAssets_RecycleBin()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id, 'tabManageAssets').when_present.click
    $browser.checkbox(:xpath, '//*[@id="manageAssetsTableItemContainer"]/tr[1]/td[1]/label/input').when_present.set
    $browser.div(:id, 'manageAssetsRestoreIcon').when_present.click
    # couldn't find a reliable solution for clicking the javascript popup.
    $browser.driver.switch_to.alert.accept
    mcs_assertion('These 1 asset have been successfully restored to their original folders.', 'Restore Assets in Recycle Bin', 'div', 'class', 'modal-message')
    $browser.button(:text,'Close').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_RestoreAssets_RecycleBin")
    $browser.refresh()
  end
end

def mcs_AdminPanel_PurgeAssets_RecycleBin()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.div(:id, 'tabManageAssets').when_present.click
    $browser.checkbox(:xpath, '//*[@id="manageAssetsTableItemContainer"]/tr[1]/td[1]/label/input').when_present.set
    $browser.div(:id, 'manageAssetsPurgeIcon').when_present.click
    # couldn't find a reliable solution for clicking the javascript popup.
    $browser.driver.switch_to.alert.accept
    mcs_assertion('These 1 asset have been successfully purged.', 'Purge Assets in Recycle Bin', 'div', 'class', 'modal-message')
    $browser.button(:text,'Close').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_PurgeAssets_RecycleBin")
    $browser.refresh()
  end
end

def mcs_AdminPanel_ManageTools_Edit()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.input(:id, 'btnEditTools').wait_until_present
    $browser.div(:id, 'tabManageTools').when_present.click
    $browser.button(:id, 'btnEditTools').when_present.click
    $browser.button(:id, 'btnUpdateTools').when_present.click
    mcs_assertion('Please confirm you would like to update user access privileges for Ci Apps.', 'Manage Tools Edit on Admin Panel', 'div', 'text', 'Please confirm you would like to update user access privileges for Ci Apps.')
    $browser.button(:class, 'btn btn-primary').when_present.click
    sleep 12
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_ManageTools_Edit")
    $browser.refresh()
  end
end

def mcs_AdminPanel_Privacy_AllowSonyAdmin()
  begin
    $browser.link(:href,'/admin').when_present.click
    $browser.checkbox(:name, 'CaaPrivacy').when_present.clear
    mcs_assertion('Confirm privacy change', 'Admin Panel Privacy Allow Sony Admin to view customer\'s assets', 'h3', 'text', 'Confirm privacy change')
    $browser.button(:text, 'Cancel').when_present.click
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_AdminPanel_Privacy_AllowSonyAdmin")
    $browser.refresh()
  end
end

def mcs_Follow_UnFollow_Folder()
  begin
    $browser.div(:text, 'Mohamed Test').when_present.click
    $browser.div(:text, 'Follow').when_present.click
    sleep 7
    mcs_assertion('Unfollow', 'Click on Follow button of a folder changes the button label to be Unfollow', 'div', 'id', 'folderinfo-follow')
    # click on the Unfollow to turn it into follow for the next test to test follow
    $browser.div(:text, 'Unfollow').when_present.click
    sleep 7
    mcs_assertion('Follow', 'Click on Unfollow button of a folder changes the button label to be Follow', 'div', 'id', 'folderinfo-follow')
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_Follow_UnFollow_Folder")
    $browser.refresh()
  end
end

def mcs_Folder_Add_User_Permission()
  begin
    $browser.div(:text, 'Mo elzein').when_present.click
    sleep 8
    $browser.div(:class, 'folder-participant').when_present.click
    sleep 3
    $browser.link(:id, 'btn-edit-permissions').when_present.click
    $browser.text_field(:id, 'txtPermSearchUser').when_present.set 'Xu Cao'
    $browser.div(:text, 'newxutest1@mailinator.com').when_present.click
    $browser.select_list(:xpath, "//*[@id=\"mcs_folder_permissions_table\"]/tbody/tr[1]/td[2]/div[2]/div[2]/select").when_present.select('Viewer')
    sleep 15
    $browser.link(:id, 'mcs_folder_permissions_done').when_present.click
    $browser.div(:id, 'mcs_folder_permissions_close').when_present.click
    sleep 7
    $browser.div(:id, 'folderinfo-edit').when_present.click
    $browser.link(:id, 'btn-edit-permissions').when_present.click
    mcs_assertion('Xu Cao', 'User Folder Permissions Username been added Test', 'b', 'text', 'Xu Cao')
    #below is to teardown for the next test to run
    $browser.div(:xpath, "//div[@data-currentpolicy='FOLDER_VIEWER']").when_present.click
    $browser.driver.switch_to.alert.accept
    sleep 7
    $browser.link(:id, 'mcs_folder_permissions_done').when_present.click
    $browser.div(:id, 'mcs_folder_permissions_close').when_present.click
    sleep 7
    $browser.refresh()
  rescue 
    mcs_failed_increment("mcs_Folder_Add_User_Permission")
  end
end

def mcs_AsperaUploadOnly()
  $browser.img(:id, 'uploadToFolder').when_present.click
  #this below js code to add local file for the upload somehow is not working anymore  will use the http upload instead
  #$browser.execute_script('javascript:var dropArray = new Array(); dropArray.push("/Users/sonyit/Desktop/MCS/Assets/DjangoIntl TV.mov"); asperaAddFiles(dropArray);')
  #click on 'Switch to basic upload' link
  #$browser.link(:id, 'asset-upload-usehttp').when_present.click
  #add file to the upload page
  #$browser.div(:id, 'assetupload-add-div').when_present.click
  #$browser.execute_script('javascript:var dropArray = new Array(); dropArray.push("/Users/sonyit/Desktop/MCS/Assets/DjangoIntl TV.mov"); McsControllersAssetUpload.asperaAddFiles(dropArray);')
  $browser.link(:id, 'asset-upload-usehttp').when_present.click
  $browser.file_field(:id, 'file').when_present.set '/Users/sonyit/Desktop/assets/xu64.png'
  mcs_assertion('Upload Started!', 'High-spped Aspera Upload Only', 'p','text','Upload Started!')
  $browser.link(:id, 'assetupload-exit').when_present.click
end

def mcs_HttpUploadOnly()
  $browser.div(:text, 'Upload').when_present.click
  #this below js code to add local file for the upload somehow is not working anymore  will use the http upload instead
  #$browser.execute_script('javascript:var dropArray = new Array(); dropArray.push("/Users/sonyit/Desktop/assets/uploadonly.mp4"); asperaAddFiles(dropArray);')
  #click on 'Switch to basic upload' link
  $browser.link(:id, 'asset-upload-usehttp').when_present.click
  #add file to the upload page
  #$browser.div(:id, 'assetupload-add-div').when_present.click
  $browser.file_field(:id, 'file').when_present.set '/Users/sonyit/Desktop/assets/uploadonly.mp4'
  $browser.link(:id, 'assetupload-uploadonly').when_present.click
  mcs_assertion('Upload Done!', 'Basic Http Upload Only', 'p','text','Upload Done!')
  $browser.link(:id, 'assetupload-exit').when_present.click
end

def mcs_AsperaUploadWithAssetDescription()
  $browser.div(:text, 'Upload').when_present.click
  #this below js code to add local file for the upload somehow is not working anymore  will use the http upload instead
  #$browser.execute_script('javascript:var dropArray = new Array(); dropArray.push("/Users/sonyit/Desktop/assets/upload-w-asset-desc.mp4"); asperaAddFiles(dropArray);')
  $browser.div(:id, 'assetupload-add-div').when_present.click
  $browser.div(:text, 'Advanced Options').when_present.click
  $browser.text_field(:id, 'assetupload_description').when_present.set 'This is an upload with asset description from Ruby automation'
  $browser.text_field(:id, 'assetupload_description').text.include? 'This is an upload with asset description from Ruby automation'
  $browser.link(:id, 'assetupload-uploadonly').when_present.click
  mcs_assertion('Upload Started!', 'Upload with asset description', 'p','text','Upload Started!')
  $browser.link(:id, 'assetupload-exit').when_present.click
end

def mcs_session_out_first_browser()
  $browser.refresh
  sleep(3)
  mcs_text_assertion('Session Expire on First browser',"LoggedOut")
end

def mcs_start_second_browser()
  browser_second = ''
  first_browser = $browser.driver.browser.to_s.downcase
    case first_browser
      when 'chrome'
        browser_second = 'firefox'
      when 'firefox'
        browser_second = 'chrome'
    end
  $browser2 = Watir::Browser.new browser_second.to_sym
  $browser2.goto $envURL
  $browser2.wait()
  mcs_text_assertion_second_browser('Launch Application on Second Browser','Login')
end

######## MCS Login on multiple browser ########
def mcs_Login_second_browser(username, password) # Logins same user on second browser
  # Login into second browser
  $browser2.text_field(:id, "Email").when_present.set(username)
  $browser2.text_field(:id, "Password").when_present.set(password)
  $browser2.send_keys :enter
  sleep(3)
  if $browser2.html.include? "You currently have Ci open in another browser elsewhere"
	puts "Already Login on Another Browser"
	$browser2.div(:class => 'boxshadow-black user-app').when_present.click
  end
  mcs_text_assertion_second_browser('Start Second Browser','Home - Sony MCS')
  sleep(3)
  mcs_second_browser_logout()
end

def mcs_invalid_login(username, password) # Logins a user from - logins.xlsx
  $browser.text_field(:id, "Email").when_present.set(username)
  $browser.text_field(:id, "Password").when_present.set(password)
  $browser.send_keys :enter
  $browser.wait()
  sleep(2)
  mcs_text_assertion('Failed login','The username and password combination you entered is not recognized')
end

def mcs_login_logout(env,username, password) # Logins a user from - logins.xlsx
  $browser.text_field(:id, "Email").when_present.set(username)
  $browser.text_field(:id, "Password").when_present.set(password)
  $browser.send_keys :enter
  $browser.wait()
  if $browser.html.include? "You currently have Ci open in another browser elsewhere"
  	puts "Already Login on Another Browser"
  	$browser.div(:class => 'boxshadow-black user-app').click
  end
  if env == 'Prod'
    mcs_assertion('MCS Engineering Team', 'Check for MCS Engineering Team link','div','id','body-container')
    mcs_assertion('Superstar Studios', 'Check for Superstar Studios link','div','id','body-container')
    mcs_assertion('Sign Out', 'Check for Sign Out','div','id','body-container')
    mcs_assertion('', 'Check for Arrow','div','class','mcs-lightgray-arrowright-big')
    $browser.link(:text, 'Sign Out').when_present.click
  else
    $browser.span(:id, 'userAccountName').when_present.click
    $browser.link(:text, 'Sign Out').when_present.click
  end
  $browser.wait()
  mcs_text_assertion('Logout',"Login")
  $browser.wait()
  mcs_text_assertion('Check Footer Text','Sony Media Cloud Services. All rights reserved')
end

def mcs_launch_account(env,username, password) # Logins a user from - logins.xlsx
  $browser.text_field(:id, "Email").when_present.set(username)
  $browser.text_field(:id, "Password").when_present.set(password)
  $browser.send_keys :enter
  $browser.wait()
  if $browser.html.include? "You currently have Ci open in another browser elsewhere"
  	puts "Already Login on Another Browser"
  	$browser.div(:class => 'boxshadow-black user-app').click
  end
  if env == 'Prod'
  #Click on white space
browser = $browser
    browser.execute_script <<-JS
    x = document.getElementById("body-container").offsetTop
    element = document.elementFromPoint(0,x-20);
    element.click()
   JS
   mcs_assertion('Superstar Studios', 'Check if click on white space then it doesn\'t redirect to next page','div','id','body-container')
   end
  #Click on MCS Engineering team link
  $browser.div(:xpath, '//*[@id="body-container"]/form[1]/div').when_present.click
  $browser.wait()
  mcs_assertion('MCS Engineering Team', 'Check for MCS Engineering Team link afteer login','div','class','head-left')
  account_name = $firstName+ " " + $lastName 
  mcs_assertion(account_name, 'Verify Account Name','span','id','userAccountName')
  $browser.span(:id, 'userAccountName').when_present.click
  $browser.link(:text, 'Sign Out').when_present.click
  $browser.wait()
  mcs_text_assertion('Logout',"Login")
  mcs_text_assertion('Check Footer Text','Sony Media Cloud Services. All rights reserved')
end

### some old code
# def mcs_ForgotPassword() # Tests forget password feature
  # $browser.link(:id, "MyaccountLink").when_present.click
  # $browser.link(:text, "Sign Out").when_present.click
  # $browser.goto $envURL
  # $browser.link(:text, "Reset your password").when_present.click
  # $browser.text_field(:id, "Email").when_present.set($userName)
  # $browser.send_keys :enter
  # mcs_text_assertion('Forgot Password', 'Thank you, an e-mail with instructions on how to reset your password will be sent to you shortly.')
# end