require 'rubygems'
require 'active_support/secure_random'
require "helpers/readExcel.rb"
require "helpers/setup.rb"
require "templates/blueGreen/template.rb"

def ws_ClickSendToEmail()
    if $isTestingTeamsite
      $browser.button(:class, 'open-share').when_present.click
      #$browser.link(:text, 'To Email').when_present.click
    else
      $browser.link(:class, 'open-share').when_present.click
    end  
end

def ws_GoToWorkspace(myWorkspaceName)
  if $isTestingTeamsite
    $browser.link(:text, 'My Dashboard').when_present.click
    $browser.link(:text, myWorkspaceName).when_present.click
  end  
end

def ws_OpenNavigator()
    if $isTestingTeamsite
      if $browser.div(:class, 'span1').link(:id, 'open-navigator-2').exists?
        $browser.div(:class, 'span1').link(:id, 'open-navigator-2').when_present.click
      end
    else
      if $browser.div(:class, 'span1').link(:id, 'open-navigator').exists?
        $browser.div(:class, 'span1').link(:id, 'open-navigator').when_present.click
      end      
    end  
end

def ws_CloseNavigator()
    if $isTestingTeamsite
      $browser.div(:id, 'file-navigator-panel-2').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    else
      $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    end
    $browser.refresh()
    # if $isTestingTeamsite
      # $browser.goto $envHome
    # end  
end

def ws_IndividualPlanDowngrade(downgrade_to_link)
    ws_Helper_DowngradePlan(downgrade_to_link)
    ci_ScreenCapture("DowngradeBackToBasicPlanTest")
    mcs_assertion("0 B / 5 GB", 'Downgrade Back To Basic Plan Data Limit Test', 'div', 'class', 'gb')
end

def ws_DeleteTeamWorkspace()
    $browser.goto $envHome
    $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
    $browser.link(:text, 'Manage Account').when_present.click
    $browser.link(:text, 'Delete').when_present.click
    $browser.button(:text, 'Delete').when_present.click
    $browser.refresh()  
end

def ws_Helper_Fill_Billing_Forms(cc_no, cc_cvv, cc_exp_mm, cc_exp_yyyy, bill_addr1, bill_addr2, bill_city, bill_state, bill_zip)
    $browser.text_field(:id, 'cc_no').when_present.set cc_no
    $browser.text_field(:id, 'cc_cvv').when_present.set cc_cvv
    $browser.select_list(:id,'cc_exp_mm').when_present.select(cc_exp_mm)
    $browser.select_list(:id,'cc_exp_yyyy').when_present.select(cc_exp_yyyy)
    $browser.text_field(:id, 'bill_address1').when_present.set bill_addr1
    $browser.text_field(:name, 'bill_address2').when_present.set bill_addr2
    $browser.text_field(:name, 'bill_city').when_present.set bill_city
    $browser.select_list(:id, 'bill_state_prov').when_present.select bill_state
    $browser.text_field(:name, 'bill_postal_cd').when_present.set bill_zip
    $browser.input(:id, 'purchase').when_present.click
end

def ws_Helper_DowngradePlan(downgrade_to_link)
    ws_Helper_Go_Back_To_MyAccount()
    $browser.link(:text, 'Current Subscriptions').when_present.click
    $browser.link(:text, 'Change').when_present.click
    $browser.link(:xpath, downgrade_to_link).when_present.click
    $browser.goto $wsHome
end

def ws_Helper_Go_Back_To_MyAccount()
  if $isTestingTeamsite
    $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
    $browser.link(:text, 'Manage Account').when_present.click
    $browser.windows.last.use
  else
    $browser.link(:class, 'dropdown-toggle').when_present.click
    $browser.link(:text, 'Manage Account').when_present.click
    $browser.link(:id, 'trigger-change-password').when_present.click
  end 
end

def aria_Verify(username, password, acct_user_id, supplemental_plan)
  envReadExcel('Aria', 'Stage')
  $browser.goto $envURL
  $browser.text_field(:id, 'username').when_present.set(username)
  $browser.text_field(:id, 'password').when_present.set(password)
  $browser.send_keys :enter 
  $browser.link(:data_aria_nav, '2').div(:text, 'Accounts').when_present.click
  $browser.link(:data_aria_nav, '21').div(:text, 'Search').when_present.click
  $browser.div(:text, 'Ad-Hoc Search').when_present.click
  $browser.select_list(:name, 'searchField1').when_present.select('Account User ID')
  $browser.text_field(:id, 'searchValueText1').when_present.set(acct_user_id)
  $browser.send_keys :enter
  $browser.link(:class, 'doAccountsPanel').when_present.click
  if supplemental_plan == 'Plus'
    mcs_assertion('Individual - Plus', 'Supplemental Plans Individual Plus Plan Label test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[1]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr[4]/td[4]')
    mcs_assertion('10.00', 'Individual Plus Plan Recent Invoice Amount test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[6]')
  elsif supplemental_plan == 'Pro'
    mcs_assertion('Individual - Pro', 'Supplemental Plans Individual Pro Plan Label test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[1]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr[4]/td[4]')
    mcs_assertion('15.00', 'Individual Pro Plan Recent Invoice Amount test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[6]')    
  elsif supplemental_plan == '250GB'
    mcs_assertion('Team - Small', 'Supplemental Plans Team Small Plan Label test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[1]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr[4]/td[4]')
    mcs_assertion('25.00', 'Team Small Plan Recent Invoice Amount test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[6]') 
  elsif supplemental_plan == '500GB'
    mcs_assertion('Team - Medium', 'Supplemental Plans Team Medium Plan Label test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[1]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr[4]/td[4]')
    mcs_assertion('50.00', 'Team Medium Plan Recent Invoice Amount test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[6]')
  elsif supplemental_plan == '1T'
    mcs_assertion('Team - Large', 'Supplemental Plans Team Large Plan Label test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[1]/tbody/tr/td/table/tbody/tr/td/table/tbody/tr[4]/td[4]')
    mcs_assertion('150.00', 'Team Large Plan Recent Invoice Amount test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[6]')
  end
  mcs_assertion('0.00', 'Recent Invoice Balance Due test', 'td', 'xpath', '//*[@id="content-wrapper"]/table[2]/tbody/tr[2]/td[8]')
  # $browser.send_keys :space
end

def ws_CreateTeamWorkspace(cc_no, cc_cvv, cc_exp_yyyy, bill_zip, create_team_workspace_link, create_team_workspace_plan, team_spec)
  # begin
    $browser.link(:text, 'My Workspace').when_present.click
    $browser.link(:text, 'My Dashboard').when_present.click
    $browser.link(:href, '/manage/plans/team').when_present.click
    $browser.link(:href, create_team_workspace_link).when_present.click
    if $browser.link(:id, 'update-payment-info').exists? && $browser.link(:id, 'update-payment-info').visible?
      $browser.link(:id, 'update-payment-info').when_present.click
    end
    if $browser_type == 'safari'
      $browser.link(:id, 'update-payment-info').when_present.click
    end
    ws_Helper_Fill_Billing_Forms(cc_no, cc_cvv, '06', cc_exp_yyyy, '2901 S Sepulveda Blvd', 'APT#107', 'Los Angeles', 'California', bill_zip)
    $browser.button(:id, 'submit-purchase').when_present.click #click okay on confirmation popup
    $browser.h3(:text, '3. Build Your Team').wait_until_present
    ci_ScreenCapture("CreateTeamAndInviteUsersTest")
    mcs_assertion('Team Workspace Name', 'Team Workspace Name Text Label Test', 'h3', 'xpath', '//*[@id="ManageWorkspace"]/div[1]/div[2]/h3')
    mcs_assertion('Invite Users', 'Invite Users Text Label Test', 'h3', 'text', 'Invite Users')
    team_name = 'QA Automation Team'+ ActiveSupport::SecureRandom.hex(3)
    $browser.text_field(:value, 'Untitled Workspace').when_present.set team_name
    $browser.text_field(:name, 'emails[0]').when_present.set 'ciapiperftest@yopmail.com'
    $browser.input(:value, 'Create & Invite').when_present.click
    $browser.link(:text, 'Take me to my Workspace').when_present.click
    
    $browser.goto $wsHome
    # $browser.h1(:text, "Let's Begin!").wait_until_present
    ci_ScreenCapture("TeamWorkspaceCreatedTest")
    mcs_assertion(team_name, 'Team Workspace Creation Test', 'h2', 'data_qa_team_plan_name', team_spec)
    #### below is the delete team workspace test and also serves as a tear down to prep for the next test run ####
    # $browser.link(:xpath, '/html/body/div[4]/div/div/div/div/div[3]/ul/li[3]/a').when_present.click
    # $browser.link(:text, 'Manage Account').when_present.click
    # $browser.link(:class, 'brand').when_present.click
    ci_ScreenCapture("NewTeamWorkspaceOnDashboardTest")
    teamNameMatch = ($browser.h2(:data_qa_team_plan_name, team_spec).text == team_name) ? 'Passed' : 'Failed'
    mcs_assertPassed('Team Workspace Name Show up on Dashboard Test', team_name, teamNameMatch, 'text')
    if create_team_workspace_plan == '250GB'
      acctUserIDinAria = $browser.div(:data_qa_team_plan_manage, 'Team - Small 25 GB').when_present.attribute_value "data-workspace-id"
    elsif create_team_workspace_plan == '500GB'
      acctUserIDinAria = $browser.div(:data_qa_team_plan_manage, 'Team - Medium 100 GB').when_present.attribute_value "data-workspace-id"
    elsif create_team_workspace_plan == '1TB'
      acctUserIDinAria = $browser.div(:data_qa_team_plan_manage, 'Team - Large 1000 GB').when_present.attribute_value "data-workspace-id"
    end
    puts acctUserIDinAria
    # if create_team_workspace_plan == '250GB'
      # teamSpecMatch = ($browser.p(:xpath, '/html/body/div[6]/div/div/div[2]/div/div[2]/p[2]').text.include? 'Team - Small 10 GB') ? 'Passed' : 'Failed'
      # mcs_assertPassed('Team Workspace Storage 10GB on Dashboard Test', 'Team - Small 10 GB', teamSpecMatch, 'xpath')
    # elsif create_team_workspace_plan == '500GB'
      # teamSpecMatch = ($browser.p(:xpath, '/html/body/div[6]/div/div/div[2]/div/div[2]/p[2]').text.include? 'Team - Medium 100 GB') ? 'Passed' : 'Failed'
      # mcs_assertPassed('Team Workspace Storage 100GB on Dashboard Test', 'Team - Medium 100 GB', teamSpecMatch, 'xpath')
    # elsif create_team_workspace_plan == '1TB'
      # teamSpecMatch = ($browser.p(:xpath, '/html/body/div[6]/div/div/div[2]/div/div[2]/p[2]').text.include? 'Team - Large 1000 GB') ? 'Passed' : 'Failed'
      # mcs_assertPassed('Team Workspace Storage 1000GB on Dashboard Test', 'Team - Large 1000 GB', teamSpecMatch, 'xpath')
    # end
    if create_team_workspace_plan == '250GB'
      $browser.div(:data_qa_team_plan_manage, 'Team - Small 25 GB').when_present.click  #click on Manage link in the team workspace box
    elsif create_team_workspace_plan == '500GB'
      $browser.div(:data_qa_team_plan_manage, 'Team - Medium 100 GB').when_present.click  #click on Manage link in the team workspace box
    elsif create_team_workspace_plan == '1TB'
      $browser.div(:data_qa_team_plan_manage, 'Team - Large 1000 GB').when_present.click  #click on Manage link in the team workspace box
    end
    $browser.div(:xpath, '//*[@id="ManageWorkspace"]/div[1]/div[2]/div[2]/div[2]/div[1]').wait_until_present
    ci_ScreenCapture("InviteUsersFromManageOnDashboard")
    # mcs_assertElementPresent('User was added to Team workspace as a member Test', 'input', 'name', 'existingusers[1].Name')
    inviteUserTestStatus = ($browser.div(:xpath, '//*[@id="ManageWorkspace"]/div[1]/div[2]/div[2]/div[2]/div[1]').when_present.text.include? 'ciapiperftest@yopmail.com') ? 'Passed' : 'Failed'
    mcs_assertPassed('Invite User Show up from Dashboard->Manage Test', 'ciapiperftest@yopmail.com', inviteUserTestStatus, '//*[@id="ManageWorkspace"]/div[1]/div[2]/div[2]/div[2]/div[1]')
    $browser.text_field(:name, 'emails[0]').when_present.set 'anotherteammember@yopmail.com'
    $browser.button(:text, 'Save Changes').when_present.click
    $browser.refresh()
    aria_Verify('sonymcs2', 'sonymcs1', acctUserIDinAria, create_team_workspace_plan)
    $browser.goto $wsHome
    # ws_DeleteTeamWorkspace()  #can't delete team workspace now so comment this out for the time being
  # rescue
    # ci_ScreenCapture("ws_CreateTeamWorkspace_Exception_Fail") 
    # mcs_failed_increment("ws_CreateTeamWorkspace")
  # end
end

def ws_UpgradeFromBasicPlan(cc_no, is_cc_no_valid, cc_cvv, cc_exp_yyyy, bill_zip, upgrade_to_link, upgrade_to_plan, downgrade_to_link)
  # begin
    ws_Helper_Go_Back_To_MyAccount()
    # $browser.link(:text, 'Upgrade this Workspace').when_present.click
    $browser.link(:text, 'Current Subscriptions').when_present.click
    $browser.link(:text, 'Change').when_present.click
    $browser.link(:xpath, upgrade_to_link).when_present.click
    if $browser.link(:id, 'update-payment-info').exists? && $browser.link(:id, 'update-payment-info').visible?
      $browser.link(:id, 'update-payment-info').when_present.click
    end
    if $browser_type == 'safari'
      $browser.link(:id, 'update-payment-info').when_present.click
    end
    ws_Helper_Fill_Billing_Forms(cc_no, cc_cvv, '06', cc_exp_yyyy, '2901 S Sepulveda Blvd', 'APT#107', 'Los Angeles', 'California', bill_zip)
    if cc_no.length < 16 || !is_cc_no_valid
      mcs_assertion('Invalid credit card number', 'incorrect credit card length or invalid credit card number test', 'li', 'class', 'error')
    elsif cc_cvv.length > 4
      mcs_assertion('Please enter a value between 3 and 4 characters long.', 'invalid credit card security code test', 'li', 'class', 'error') 
    else
      $browser.button(:id, 'submit-purchase').when_present.click #click okay on confirmation popup
      $browser.refresh()
      # $browser.h3(:text, '3. Aspera Media Transport for Professionals').wait_until_present
      # mcs_assertion('3. Aspera Media Transport for Professionals', '3nd step for upgrading from Basic to Plus Individual', 'h3', 'text', '3. Aspera Media Transport for Professionals')
      $browser.goto $envHome
      
      if upgrade_to_plan == 'Plus'
        acctUserIDinAria = $browser.div(:data_qa_team_plan_manage, 'Individual - Plus 25 GB').when_present.attribute_value "data-workspace-id"
      elsif upgrade_to_plan == 'Pro'
        acctUserIDinAria = $browser.div(:data_qa_team_plan_manage, 'Individual - Pro 100 GB').when_present.attribute_value "data-workspace-id"
      end
      puts acctUserIDinAria
      $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
      $browser.link(:text, 'Manage Account').when_present.click
      $browser.windows.last.use
      $browser.link(:text, 'Current Subscriptions').when_present.click
      if upgrade_to_plan == 'Plus'
        ci_ScreenCapture("UpgradeFromBasicPlanToPlusTest")
        mcs_assertion("25GB", 'Upgrade To Plus Plan Verify space limit Test', 'span', 'class', 'role')
      elsif upgrade_to_plan == 'Pro'
        ci_ScreenCapture("UpgradeFromBasicPlanToProTest")
        mcs_assertion("100GB", 'Upgrade To Pro Plan Verify space limit Test', 'span', 'class', 'role')
      end
      aria_Verify('sonymcs2', 'sonymcs1', acctUserIDinAria, upgrade_to_plan)
      $browser.windows.last.use
      $browser.windows.last.close
      $browser.goto $wsHome
      #### below is the Downgrade test and also serves as a tear down to prep for the next test round ####
      ws_IndividualPlanDowngrade(downgrade_to_link)
    end
    $browser.refresh()
    # $browser.goto $envHome
    # return acctUserIDinAria
  # rescue
    # ci_ScreenCapture("ws_UpgradeToPlusPlan_Exception_Fail") 
    # mcs_failed_increment("ws_UpgradeToPlusPlan")
  # end
end

def ws_VerifyDashboard(team_name, tag_participant, network_name)
  ci_ScreenCapture("VerifyDashboardTest")
  mcs_assertion(team_name, 'Team Large Workspace Name Test', 'h2', 'data_qa_team_plan_name', 'Team - Large 1000 GB')
  mcs_assertElementPresent('Team Banner Exists Test', 'div', 'xpath', '/html/body/div[6]/div/div/div[2]/div/div[4]/div/div[1]')
  mcs_assertElementPresent('Team Logo Exists Test', 'div', 'xpath', '/html/body/div[6]/div/div/div[2]/div/div[4]/div/div[1]/a/div[1]')
  puts $browser.div(:xpath, '/html/body/div[6]/div/div/div[2]/div/div[4]/div/div[1]/a/div[2]').when_present.text
  tagParticipantMatch = ($browser.div(:xpath, '/html/body/div[6]/div/div/div[2]/div/div[4]/div/div[1]/a/div[2]').when_present.text == tag_participant) ? 'Passed' : 'Failed'
  mcs_assertPassed('Team Tag Participant Test', tag_participant, tagParticipantMatch, 'text')
  mcs_assertion(network_name, 'Team Network Name Test', 'h3', 'text', network_name)
end

def ws_FileAndStorageUsage()
  # begin
    if $isTestingTeamsite
      ws_Helper_Go_Back_To_MyAccount()
    else
      $browser.link(:class, 'dropdown-toggle').when_present.click
    end
    $browser.div(:class, 'usage-files').wait_until_present
    ci_ScreenCapture("FileAndStorageUsageTest")
    fileUsageTestStatus = ($browser.div(:class, 'usage-files').when_present.text.include? '-') ? 'Failed' : 'Passed'
    mcs_assertPassed('Negative total number of file usage Test', '- Negative sign', fileUsageTestStatus, 'usage-files')
    storageUsageTestStatus = ($browser.div(:class, 'usage-space').when_present.text.include? '-') ? 'Failed' : 'Passed'
    mcs_assertPassed('Negative total number of file usage Test', '- Negative sign', storageUsageTestStatus, 'usage-space')
    $browser.refresh()
  # rescue
    # ci_ScreenCapture("ws_FileAndStorageUsage_Exception_Fail") 
    # mcs_failed_increment("ws_FileAndStorageUsage")
  # end
end

def ws_ChangePassword()
  # begin
    ws_Helper_Go_Back_To_MyAccount()
    $browser.link(:text, 'Profile').when_present.click
    $browser.link(:href, 'javascript:changePassword.show()').when_present.click
    $browser.text_field(:id, 'oldPassword').when_present.set 'pa55w0rd'
    $browser.text_field(:id, 'newPassword').when_present.set 'sonytest123'
    $browser.text_field(:id, 'newPassword_confirm').when_present.set 'sonytest123'
    $browser.button(:id, 'submit-change-password').when_present.click
    ci_ScreenCapture("ChangePasswordConfirmationTest")
    mcs_assertion('Your password has been set', 'Ci Workspace Change Password Test', 'span', 'text', 'Your password has been set')
    #### change password again back to the original so that it can be reused for the next test
    $browser.refresh()
    if $isTestingTeamsite
      $browser.link(:href, 'javascript:changePassword.show()').when_present.click
    else
      $browser.link(:id, 'trigger-change-password').when_present.click
    end
    $browser.text_field(:id, 'oldPassword').when_present.set 'sonytest123'
    $browser.text_field(:id, 'newPassword').when_present.set 'pa55w0rd'
    $browser.button(:id, 'submit-change-password').when_present.click
    $browser.refresh()
    $browser.windows.last.close
    # $browser.div(:class, 'done to-workspace').when_present.click
    # $browser.refresh()
  # rescue
    # ci_ScreenCapture("ws_ChangePassword_Exception_Fail") 
    # mcs_failed_increment("ws_ChangePassword")
  # end
end

def ws_DuplicateExistingSignUp()
  begin
    $browser.link(:href, '/account?v=register').when_present.click
    $browser.text_field(:id,'RegisterFirstName').when_present.set 'Xu'
    $browser.text_field(:id,'RegisterLastName').when_present.set 'Cao'
    $browser.text_field(:id,'RegisterEmail').when_present.set 'xu_cao@spe.sony.com'
    $browser.text_field(:id,'RegisterPassword').when_present.set 'pa55w0rd'
    $browser.checkbox(:id,'RegisterTermsOfUse').when_present.click
    $browser.button(:value, 'Create My Workspace').when_present.click
    ci_ScreenCapture("DuplicateExistingSignUpTest")
    mcs_assertion('THERE IS ALREADY AN ACCOUNT FOR THIS EMAIL', 'Ci Workspace Duplicate existing account Test', 'h1', 'text', 'There is already an account for this email')
  rescue 
    ci_ScreenCapture("ws_DuplicateExistingSignUp_Exception_Fail")
    mcs_failed_increment("ws_DuplicateExistingSignUp")
  end
end

def ws_ValidationAcceptTermsOfUse()
  begin
    $browser.link(:href, '/account?v=register').when_present.click
    $browser.text_field(:id,'RegisterFirstName').when_present.set 'Xu'
    $browser.text_field(:id,'RegisterLastName').when_present.set 'Cao'
    $browser.text_field(:id,'RegisterEmail').when_present.set 'xu_cao@spe.sony.com'
    $browser.text_field(:id,'RegisterPassword').when_present.set 'pa55w0rd'
    $browser.button(:value, 'Create My Workspace').when_present.click
    ci_ScreenCapture("ValidationAcceptTermsOfUse")
    mcs_assertion('Please accept our Terms of Use above.', 'Ci Workspace Validate Accept Terms Of Use Test', 'label', 'text', 'Please accept our Terms of Use above.')
    $browser.img(:alt, 'Ci').when_present.click
  rescue 
    ci_ScreenCapture("ws_ValidationAcceptTermsOfUse_Exception_Fail")
    mcs_failed_increment("ws_ValidationAcceptTermsOfUse")
  end
end

def ws_SignUp()
  begin
    $browser.link(:href, '/account?v=register').when_present.click
    $browser.text_field(:id,'RegisterFirstName').when_present.set 'SignUpAutoFN'
    $browser.text_field(:id,'RegisterLastName').when_present.set 'SignUpAutoLN'
    randomUserAcct = 'SignUpAutoTest' + ActiveSupport::SecureRandom.hex(3)
    randomEmail = randomUserAcct + '@yopmail.com'
    password = 'pa55w0rd'
    $browser.text_field(:id,'RegisterEmail').when_present.set randomEmail
    $browser.text_field(:id,'RegisterPassword').when_present.set password
    $browser.checkbox(:id,'RegisterTermsOfUse').when_present.click
    $browser.button(:value, 'Create My Workspace').when_present.click
    ci_ScreenCapture("SignUpWizard1stPageTest")
    mcs_assertion('Welcome to Ci.', 'First Page of Sign-Up Wizard', 'h1', 'text', 'Welcome to Ci.')
    $browser.link(:href, 'wizard-2.html').when_present.click
    ci_ScreenCapture("SignUpWizard2ndPageTest")
    mcs_assertion('Drag & Drop Files', 'Second Page of Sign-Up Wizard', 'h1', 'text', 'Drag & Drop Files')
    $browser.link(:href, 'wizard-3.html').when_present.click
    ci_ScreenCapture("SignUpWizard3rdPageTest")
    mcs_assertion('Let\'s get to work!', 'Third Page of Sign-Up Wizard', 'h1', 'text', 'Let\'s get to work!')
    $browser.link(:href, 'wizard-4.html').when_present.click
    ci_ScreenCapture("SignUpWizard4thPageTest")
    mcs_assertion('Start a Session', 'Ci Workspace Sign Up Wizard 4th Page Test', 'h1', 'text', 'Start a Session')
    $browser.link(:href, 'done.html').when_present.click
    ci_ScreenCapture("SignUpWizard5thPageTest")
    mcs_assertion('Enough Talk', 'Ci Workspace Sign Up Wizard 5th Page Test', 'h1', 'text', 'Enough Talk')
    $browser.link(:href, '/workspace').when_present.click
    ci_ScreenCapture("SignUpWizardEndPageTest")
    mcs_assertion('Let\'s Begin!', 'Ci Workspace Sign Up Wizard End Page Test', 'h1', 'text', 'Let\'s Begin!')
    puts randomEmail
    return randomEmail,password
  #rescue
    #ci_ScreenCapture("ws_SignUp_Exception_Fail") 
   # mcs_failed_increment("ws_SignUp")
  end
end

def ws_Login(username, password)
  # begin
    $browser.link(:href, '/account?v=login').wait_until_present
    $browser.link(:href, '/account?v=login').when_present.click
    $browser.text_field(:id, 'LoginEmail').when_present.set(username)
    $browser.text_field(:id, 'LoginPassword').when_present.set(password)
    $browser.send_keys :enter
    ci_ScreenCapture("LoginTest")
    if $isTestingTeamsite
      mcs_assertion('Dashboard', 'Ci Workspace User Login with Correct Credentials Test', 'h1', 'id', 'title')
    else
      mcs_assertion('Workspace', 'Ci Workspace User Login with Correct Credentials Test', 'h1', 'id', 'title')
    end
    $email = username
  # rescue 
    # ci_ScreenCapture("ws_Login_Exception_Fail")
    # mcs_failed_increment("ws_Login")
  # end
end

def ws_ForgotPasswordWithValidEmail(validEmail)
  begin
    $browser.link(:href, '/account?v=login').when_present.click
    $browser.link(:text, 'Forgot Password?').when_present.click
    ci_ScreenCapture("ForgotPasswordPageTest")
    mcs_assertion('FORGOT YOUR PASSWORD?', 'Ci Workspace Forgot Password Link header1 tag Test', 'h1', 'text', 'Forgot your password?')
    mcs_assertion('Send me a link to reset my password', 'Ci Workspace Forgot Password Link paragraph tag Test', 'p', 'text', 'Send me a link to reset my password')
    $browser.text_field(:id, 'Email').when_present.set validEmail
    $browser.button(:text, 'Reset my password').when_present.click
    ci_ScreenCapture("SentResetPasswordPageTest")
    mcs_assertion('Email Sent', 'Ci Workspace Forgot Password Email Sent header3 tag Test', 'h3', 'text', 'Email Sent')
    mcs_assertion('If we have your email on record, an email should be arriving shortly with a link to reset your password.', 'Ci Workspace Forgot Password Email Sent paragraph tag Text1 Test', 'p', 'text', 'If we have your email on record, an email should be arriving shortly with a link to reset your password.')
    mcs_assertion('This link will be valid for 48 hours.', 'Ci Workspace Forgot Password Email Sent paragraph tag Text2 Test', 'p', 'text', 'This link will be valid for 48 hours.')
    $browser.img(:alt, 'Ci').when_present.click
  rescue 
    ci_ScreenCapture("ws_ForgotPasswordWithValidEmail_Exception_Fail")
    mcs_failed_increment("ws_ForgotPasswordWithValidEmail")
  end
end

def ws_ForgotPasswordWithInvalidEmail(invalidEmail)
  begin
    $browser.link(:href, '/account?v=login').when_present.click
    $browser.link(:text, 'Forgot Password?').when_present.click 
    $browser.text_field(:id, 'Email').when_present.set invalidEmail
    $browser.button(:text, 'Reset my password').when_present.click
    $browser.form(:id, 'form-forgot-password').div(:class, 'fieldset').label(:text, 'Valid email address, please').wait_until_present
    ci_ScreenCapture("InvalidEmailErrorTest")
    mcs_assertion('Valid email address, please', 'Ci Workspace Forgot Password with invalid Email address Test', 'label', 'text', 'Valid email address, please')
    $browser.img(:alt, 'Ci').when_present.click
  rescue 
    ci_ScreenCapture("ws_ForgotPasswordWithInvalidEmail_Exception_Fail")
    mcs_failed_increment("ws_ForgotPasswordWithInvalidEmail")
  end
end

def ws_FailedLogin(username, password)
  # begin
    $browser.link(:href, '/account?v=login').when_present.click
    $browser.text_field(:id, 'LoginEmail').when_present.set(username)
    $browser.text_field(:id, 'LoginPassword').when_present.set(password)
    $browser.send_keys :enter
    ci_ScreenCapture("FailedLoginTest")
    mcs_assertion('Invalid credentials, please try again', 'Ci Workspace User Login with Wrong Password Test', 'div', 'class', 'error')
    $browser.img(:alt, 'Ci').wait_until_present
    $browser.img(:alt, 'Ci').when_present.click
  # rescue 
    # ci_ScreenCapture("ws_FailedLogin_Exception_Fail")
    # mcs_failed_increment("ws_FailedLogin")
  # end
end

def ws_ReturnToFrontPageUsingCiLogoFromLoginScreen()
  begin
    $browser.link(:href, '/account?v=login').when_present.click
    $browser.img(:alt, 'Ci').wait_until_present
    $browser.img(:alt, 'Ci').when_present.click
    ci_ScreenCapture("CiLogoReturnToFrontPageFromLoginScreenTest")
    mcs_assertion('CI SOME OF THE AMAZING THINGS THAT CAN BE DONE IN THE CLOUD', 'Ci Return to front page from Login screen Test', 'h1', 'text', 'Ci Some of the Amazing Things that Can Be Done in the Cloud')
  rescue 
    ci_ScreenCapture("ws_ReturnToFrontPageUsingCiLogoFromLoginScreen_Exception_Fail")
    mcs_failed_increment("ws_ReturnToFrontPageUsingCiLogoFromLoginScreen")
  end
end

def ws_ReturnToFrontPageUsingCiLogoFromSignUpScreen()
  begin
    $browser.link(:href, '/account?v=register').when_present.click
    $browser.img(:alt, 'Ci').wait_until_present
    $browser.img(:alt, 'Ci').when_present.click
    ci_ScreenCapture("CiLogoReturnToFrontPageFromSignUpScreenTest")
    mcs_assertion('CI SOME OF THE AMAZING THINGS THAT CAN BE DONE IN THE CLOUD', 'Ci Return to front page from SignUp screen Test', 'h1', 'text', 'Ci Some of the Amazing Things that Can Be Done in the Cloud')
  rescue 
    ci_ScreenCapture("ws_ReturnToFrontPageUsingCiLogoFromSignUpScreen_Exception_Fail")
    mcs_failed_increment("ws_ReturnToFrontPageUsingCiLogoFromSignUpScreen")
  end
end

def ws_BackLinkInWizardTutorial()
  begin
    $browser.link(:href, '/account?v=register').when_present.click
    $browser.text_field(:id,'RegisterFirstName').when_present.set 'SignUpAutoFN'
    $browser.text_field(:id,'RegisterLastName').when_present.set 'SignUpAutoLN'
    randomUserAcct = 'SignUpAutoTest' + ActiveSupport::SecureRandom.hex(3)
    randomEmail = randomUserAcct + '@yopmail.com'
    $browser.text_field(:id,'RegisterEmail').when_present.set randomEmail
    $browser.text_field(:id,'RegisterPassword').when_present.set 'pa55w0rd'
    $browser.checkbox(:id,'RegisterTermsOfUse').when_present.click
    $browser.button(:value, 'Create My Workspace').when_present.click
    $browser.link(:href, 'wizard-2.html').when_present.click
    $browser.link(:href, 'wizard-3.html').when_present.click
    $browser.link(:href, 'wizard-4.html').when_present.click
    $browser.link(:href, 'wizard-3.html').when_present.click
    ci_ScreenCapture("SignUpWizardBackTo3rdPageTest")
    mcs_assertion('Let\'s get to work!', 'Ci Workspace Sign Up Wizard Back to 3rd Page Test', 'h1', 'text', 'Let\'s get to work!')
    $browser.link(:href, 'wizard-2.html').when_present.click
    ci_ScreenCapture("SignUpWizardBackTo2ndPageTest")
    mcs_assertion('Drag & Drop Files', 'Ci Workspace Sign Up Wizard Back to 2nd Page Test', 'h1', 'text', 'Drag & Drop Files')
    $browser.link(:href, 'wizard-1.html').when_present.click
    ci_ScreenCapture("SignUpWizardBackTo1stPageTest")
    mcs_assertion('Welcome to Ci.', 'Ci Workspace Sign Up Wizard Back to 1st Page Test', 'h1', 'text', 'Welcome to Ci.')
    $browser.link(:href, 'wizard-2.html').when_present.click
    $browser.link(:href, 'done.html').when_present.click
    $browser.link(:href, '/workspace').when_present.click
  rescue 
    ci_ScreenCapture("ws_Rws_BackLinkInWizardTutorial_Exception_Fail")
    mcs_failed_increment("ws_ws_BackLinkInWizardTutorial")
  end
end

def ws_Upload()   #courtesy by Admit Kumar
  # begin
    # ws_GoToWorkspace('My Workspace')
    assetUploadFilePath = Dir.pwd + '/input/assets/xu64.png'
    # $browser.execute_script('document.getElementById("selected-files").style.display="inline";') #tried this js and it only worked the first time in safari
    $browser.file_field(:id, 'selected-files').set assetUploadFilePath
    puts $browser.div(:class, 'screen file').div(:class, 'status').text
    sleep 4
    puts $browser.div(:class, 'screen file').div(:class, 'status').text
    sleep 4
    puts $browser.div(:class, 'screen file').div(:class, 'status').text
    ci_ScreenCapture("UploadTest")
    mcs_assertion('xu64.png', 'Ci Workspace Upload test', 'span', 'xpath', '//*[@id="files"]/div/div[4]/div[1]/div[2]/span[1]')
    helper_Wait_Until_Ready()
    $browser.span(:text, 'xu64.png').when_present.click
    $browser.link(:class, 'trigger-recycle').when_present.click
    ws_OpenNavigator()
    $browser.link(:href, 'javascript:screens.load(\'recycle\')').when_present.click
    $browser.link(:class, 'trigger-delete-all').when_present.click
    ws_CloseNavigator()
  # rescue 
    # ci_ScreenCapture("ws_Upload_Exception_Fail")
    # mcs_failed_increment("ws_Upload")
  # end
end

def helper_Wait_Until_Ready()
  begin
  $browser.wait_until { $browser.div(:class => 'screen file').div(:class => 'status').text.include?("Ready") == false }
  rescue Watir::Wait::TimeoutError
  puts 'There is a timeout however no need to worry'
  retry
  end
end

def ws_CreateNewFolderUnderWorkspace()
  begin
    $browser.link(:class, 'open-create-folder').when_present.click
    ci_ScreenCapture("clickOnCreateNewFolderTest")
    mcs_assertion('Create a New Folder', 'Ci Workspace Create a New Folder icon popup test', 'h1', 'text', 'Create a New Folder')
    randomFolderName = 'XuFolderTest' + ActiveSupport::SecureRandom.hex(3)
    $browser.text_field(:id, 'create-folder-name').when_present.set(randomFolderName)
    $browser.button(:id, 'submit-create-folder').when_present.click
    folderCreationConfirmationMsg = 'Folder ' + randomFolderName + ' has been created'
    $browser.span(:text, folderCreationConfirmationMsg).wait_until_present
    ci_ScreenCapture("NewFolderCreatedConfirmationTest")
    mcs_assertion(folderCreationConfirmationMsg, 'Ci Workspace New Folder has been created test', 'span', 'text', folderCreationConfirmationMsg)
    #below is the kind of teardown to delete this test folder so that it won't adding lots of testing folders 
    # to clutter the workspace and push the test asset off the screen so that it won't cause other tests to fail
    $browser.span(:text, randomFolderName).when_present.click
    $browser.link(:class, 'trigger-recycle').when_present.click
    ws_OpenNavigator()
    $browser.li(:id, 'trigger-recycle').link(:text, 'Recycle Bin').when_present.click
    $browser.span(:text, randomFolderName).wait_until_present
    $browser.span(:text, randomFolderName).when_present.click
    $browser.link(:class, 'trigger-delete').when_present.click
    $browser.li(:text, "Workspace").when_present.click
    ws_CloseNavigator()
    $browser.refresh()
  #rescue 
   # ci_ScreenCapture("ws_CreateNewFolderUnderWorkspace_Exception_Fail")
    #mcs_failed_increment("ws_CreateNewFolderUnderWorkspace")
    #$browser.li(:text, "Workspace").when_present.click
    #$browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    #$browser.refresh()
  end
end

def ws_Share()
  # begin
    # ws_GoToWorkspace('My Workspace')
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    # $browser.img(:xpath, "//img[contains(@alt, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')]").when_present.click
    ws_ClickSendToEmail()
    $browser.text_field(:id, 'share-subject').when_present.set 'Test Share subject by automation'
    $browser.textarea(:id, 'share-message').when_present.set 'Test Share message by automation'
    $browser.text_field(:id, 'share-recipients').when_present.set 'ciworkspacesharingtest@yopmail.com'
    $browser.checkbox(:id, 'share-allow-download').when_present.set
    $browser.select_list(:id,'share-ttl').when_present.select('One Month')
    $browser.button(:text, 'Share').when_present.click
    ci_ScreenCapture("FileShareTest")
    mcs_assertion('Your file has been shared', 'Ci Workspace Share test', 'p', 'text', 'Your file has been shared')
    $browser.refresh()
  # rescue 
    # ci_ScreenCapture("ws_Share_Exception_Fail")
    # mcs_failed_increment("ws_Share")
  # end
end

def ws_ShareWithMultipleRecipients()
  begin
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    # $browser.img(:xpath, "//img[contains(@alt, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')]").when_present.click
    ws_ClickSendToEmail()
    $browser.text_field(:id, 'share-subject').when_present.set 'Test Share subject by automation'
    $browser.textarea(:id, 'share-message').when_present.set 'Test Share message by automation'
    $browser.text_field(:id, 'share-recipients').when_present.set 'share1@mailinator.com, share2@mailinator.com'
    $browser.checkbox(:id, 'share-allow-download').when_present.set
    $browser.select_list(:id,'share-ttl').when_present.select('One Month')
    $browser.button(:text, 'Share').when_present.click
    ci_ScreenCapture("FileShareWithMultipleRecipientsTest")
    mcs_assertion('Your file has been shared', 'Ci Workspace Share With Multiple Recipients test', 'p', 'text', 'Your file has been shared')
    $browser.refresh()
    $browser.goto 'share1.mailinator.com'
    $browser.div(:text, 'ci@agorapic.com').wait_until_present  # waiting for emails reach to mailinator's inbox
    ci_ScreenCapture("RecipientOneReceiveEmailTest")
    mcs_assertion('ci@agorapic.com', 'Recipient One Receive Share Email test', 'div', 'text', 'ci@agorapic.com')
    $browser.goto 'share2.mailinator.com'
    $browser.div(:text, 'ci@agorapic.com').wait_until_present
    ci_ScreenCapture("RecipientTwoReceiveEmailTest")
    mcs_assertion('ci@agorapic.com', 'Recipient Two Receive Share Email test', 'div', 'text', 'ci@agorapic.com')
    $browser.goto $envHome
  rescue 
    ci_ScreenCapture("ws_ShareWithMultipleRecipients_Exception_Fail")
    mcs_failed_increment("ws_ShareWithMultipleRecipients")
    $browser.goto $envHome
  end
end

def ws_CorrectAssetDisplayedOnShare()
  begin
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'open-share').when_present.click 
    $browser.b(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    ci_ScreenCapture("CorrectAssetDisplayedOnShareTest")
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Check that the correct asset is displayed on share modal', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    $browser.refresh()
  rescue 
    ci_ScreenCapture("ws_CorrectAssetDisplayedOnShares_Exception_Fail")
    mcs_failed_increment("ws_CorrectAssetDisplayedOnShare")
  end
end

def ws_RetrieveShareLink()
  # begin
    ws_GoToWorkspace('My Workspace')
    share_recipient_email = 'ciworkspacesharingtest@yopmail.com'
    share_subject = 'WS Test Share subject by automation'
    share_message = 'WS Test Share message by automation'
    login_email = 'xu_cao@spe.sony.com'
    login_password = 'pa55w0rd'
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    ws_ClickSendToEmail()
    $browser.text_field(:id, 'share-subject').when_present.set share_subject
    $browser.textarea(:id, 'share-message').when_present.set share_message
    $browser.text_field(:id, 'share-recipients').when_present.set share_recipient_email
    $browser.checkbox(:id, 'share-allow-download').when_present.set
    $browser.select_list(:id,'share-ttl').when_present.select('One Month')
    $browser.button(:text, 'Share').when_present.click
    ci_ScreenCapture("ShareModalTest")
    mcs_assertion('Your file has been shared', 'Ci Workspace Share test', 'p', 'text', 'Your file has been shared')
    share_url = $browser.div(:class, 'share-link').when_present.text
    $browser.div(:id, 'modal-share').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
    ws_Logout()
    $browser.goto share_url
    $browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').wait_until_present
    ci_ScreenCapture("SharedPageElementsWithoutLoginTest")
    mcs_assertion(share_subject, 'Share recipient email present Test', 'h1', 'text', share_subject)
    mcs_assertion('Expires in 29 days', 'Share expiration in days', 'div', 'class', 'share-expiration')
    # mcs_assertion(share_message, 'Share expiration in days text test', 'div', 'class', 'message')
    mcs_assertion(share_url, 'Share link is present on share page text test', 'div', 'class', 'share-link')
    mcs_assertion('Sign Up', 'Sign Up on share page text test', 'link', 'text', 'Sign Up')
    mcs_assertion('Sign In', 'Sign In on share page text test', 'link', 'text', 'Sign In')
    withoutLoginTestStatus = ($browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').when_present.html.include? '<video type="video/mp4"') ? 'Passed' : 'Failed'
    mcs_assertPassed('Preview Video tag is present on Share page Test', 'Video html5 tag', withoutLoginTestStatus, 'video type="video/mp4"')
    $browser.link(:text, 'Sign In').when_present.click
    $browser.text_field(:id, 'LoginEmail').when_present.set(login_email)
    $browser.text_field(:id, 'LoginPassword').when_present.set(login_password)
    $browser.send_keys :enter
    $browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').wait_until_present
    ci_ScreenCapture("SharedPageElementsAfterLoginTest")
    mcs_assertion(share_subject, 'Share recipient email present Test', 'h1', 'text', share_subject)
    mcs_assertion('Expires in 29 days', 'Share expiration in days', 'div', 'class', 'share-expiration')
    # mcs_assertion(share_message, 'Share expiration in days text test', 'div', 'class', 'message')
    mcs_assertion(share_url, 'Share link is present on share page text test', 'div', 'class', 'share-link')
    mcs_assertion('Download', 'After login share page Download text test', 'h3', 'text', 'Download')
    mcs_assertion('Source mp4, 3 MB', 'Download source icon text test', 'div', 'class', 'download-link')
    withoutLoginTestStatus = ($browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').when_present.html.include? '<video type="video/mp4"') ? 'Passed' : 'Failed'
    mcs_assertPassed('Preview Video tag is present on Share page Test', 'Video html5 tag', withoutLoginTestStatus, 'video type="video/mp4"')
  # rescue 
    # ci_ScreenCapture("ws_RetrieveShareLink_Exception_Fail")
    # mcs_failed_increment("ws_RetrieveShareLink")
  # end
end

def ws_PreviewModalStarUnstar()
  # begin
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'open-preview').when_present.click 
    $browser.li(:xpath, '//*[@class="preview-action"]/li[1]').i(:class, 'icon-star-filled toggle-star').when_present.click
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
    ws_OpenNavigator()
    $browser.li(:id, 'trigger-starred').link(:text, 'Starred').when_present.click
    ci_ScreenCapture("PreviewModalStarTest")
    mcs_assertElementPresent('Ci Workspace Preview Modal Star Test', 'span', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    # unstar test also it will be ready for the next test
    $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'open-preview').when_present.click
    $browser.li(:xpath, '//*[@class="preview-action"]/li[1]').i(:class, 'icon-star-filled toggle-star').when_present.click 
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh
    $browser.li(:id, 'trigger-starred').link(:text, 'Starred').when_present.click
    ci_ScreenCapture("PreviewModalUnStarTest")
    mcs_assertElementPresent('Ci Workspace Preview Modal UnStar Test', 'div', 'text', 'nothing here')  
    ws_CloseNavigator()
    $browser.refresh()  
  # rescue 
    # ci_ScreenCapture("ws_PreviewModalStar_Exception_Fail")
    # mcs_failed_increment("ws_PreviewModalStarAndUnStar")
    # $browser.refresh()
  # end  
end

def ws_PreviewModalSingleAssetShare()
  begin
    $browser.div(:data_sort_name, 'boom_premiere_sizzle_v1-proxy-hi.mp4').when_present.click  #new way to use customized attributes just replace - with _
    # $browser.div(:xpath, "//div[contains(@data-sort-name, 'boom_premiere_sizzle_v1-proxy-hi.mp4')]").when_present.click #old way using xpath
    $browser.link(:class, 'open-preview').when_present.click 
    $browser.li(:class, 'trigger-share').i(:class, 'icon-send').when_present.click
    $browser.h3(:text, 'Share To').wait_until_present
    ci_ScreenCapture("PreviewModalSingleAssetShareTest")
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Share on Preview check single file presents on modal', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('Share', 'Ci Workspace Preview Modal Single Share text Test', 'h1', 'text', 'Share')
    mcs_assertion('Share To', 'Ci Workspace Preview Modal Single Share To text Test', 'h3', 'text', 'Share To') 
    $browser.div(:id, 'modal-share').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
  rescue 
    ci_ScreenCapture("ws_PreviewModalSingleAssetShare_Exception_Fail")
    mcs_failed_increment("ws_PreviewModalSingleAssetShare")
    $browser.refresh()
  end
end

def ws_PreviewModalMultiAssetsShare()
  # begin
    share_recipient_email = 'multiassetssharingtest@yopmail.com'
    share_subject = 'Multi Assets Share subject by automation'
    share_message = 'Multi Assets Share message by automation'
    login_email = 'xu_cao@spe.sony.com'
    login_password = 'pa55w0rd'
    $browser.div(:xpath, "//div[contains(@data-sort-name, 'boom_premiere_sizzle_v1-proxy-hi.mp4')]").div(:class, "thumbnails").div(:class, "check").click
    $browser.div(:xpath, "//div[contains(@data-sort-name, 'brazil.png')]").div(:class, "thumbnails").div(:class, "check").click
    ws_ClickSendToEmail()
    $browser.b(:text, 'Brazil.png').wait_until_present
    ci_ScreenCapture("PreviewModalMultiAssetsShareTest")
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Share on Preview check multiple files .mp4 presents on modal', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('TASM_TVSCRN28_R6_NEW2.jpg', 'Share on Preview check multiple files .jpg presents on modal', 'b', 'text', 'TASM_TVSCRN28_R6_NEW2.jpg')
    mcs_assertion('Brazil.png', 'Share on Preview check mutltiple files .png presents on modal', 'b', 'text', 'Brazil.png')
    mcs_assertion('Share', 'Ci Workspace Preview Modal multi Share text Test', 'h1', 'text', 'Share')
    mcs_assertion('Share To', 'Ci Workspace Preview Modal multi Share Test', 'h3', 'text', 'Share To') 
    $browser.text_field(:id, 'share-subject').when_present.set share_subject
    $browser.textarea(:id, 'share-message').when_present.set share_message
    $browser.text_field(:id, 'share-recipients').when_present.set share_recipient_email
    $browser.checkbox(:id, 'share-allow-download').when_present.set
    $browser.select_list(:id,'share-ttl').when_present.select('One Month')
    $browser.button(:text, 'Share').when_present.click
    share_url = $browser.div(:class, 'share-link').when_present.text
    $browser.div(:id, 'modal-share').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
    ws_Logout()
    $browser.goto share_url
    ci_ScreenCapture("MultiAssetsShareOnSharedLinkPageBeforeSignIn")
    mcs_assertElementPresent('Spider image made it on shared link page before login', 'img', 'xpath', "//img[contains(@alt, 'TASM_TVSCRN28_R6_NEW2.jpg')]")
    withoutLoginTestStatus = ($browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').when_present.html.include? '<video type="video/mp4"') ? 'Passed' : 'Failed'
    mcs_assertPassed('Preview Video tag is present on Share page Test before login', 'Video html5 tag', withoutLoginTestStatus, 'video type="video/mp4"')  # check if boom video made it
    mcs_assertElementPresent('Brazil image made it on shared link page before login', 'img', 'xpath', "//img[contains(@alt, 'Brazil.png')]")
    mcs_assertion('Expires in 29 days', 'Expiration day on shared link page test', 'div', 'class', 'share-expiration')
    $browser.link(:text, 'Sign In').when_present.click
    $browser.text_field(:id, 'LoginEmail').when_present.set(login_email)
    $browser.text_field(:id, 'LoginPassword').when_present.set(login_password)
    $browser.send_keys :enter
    ci_ScreenCapture("MultiAssetsShareOnSharedLinkPageBeforeSignIn")
    mcs_assertElementPresent('Spider image made it on shared link page after login', 'img', 'xpath', "//img[contains(@alt, 'TASM_TVSCRN28_R6_NEW2.jpg')]")
    withoutLoginTestStatus = ($browser.div(:xpath, '//*[@id="sharedVideo_1dace1d2288e4967ae4b7bfd94b58e78"]').when_present.html.include? '<video type="video/mp4"') ? 'Passed' : 'Failed'
    mcs_assertPassed('Preview Video tag is present on Share page Test after login', 'Video html5 tag', withoutLoginTestStatus, 'video type="video/mp4"')  # check if boom video made it
    mcs_assertElementPresent('Brazil image made it on shared link page after login', 'img', 'xpath', "//img[contains(@alt, 'Brazil.png')]")
    mcs_assertion('Expires in 29 days', 'Expiration day on shared link page test', 'div', 'class', 'share-expiration')
    $browser.div(:xpath, '/html/body/div[6]/div/div/div/div[2]/div[3]').when_present.click #manually inspect the 2nd shared asset can be downloaded
    $browser.send_keys :space
    $browser.div(:xpath, '/html/body/div[7]/div/div/div/div[2]/div[3]').when_present.click #manually inspect the 2nd shared asset can be downloaded
    $browser.goto $envHome
  # rescue 
    # ci_ScreenCapture("ws_PreviewModalMultiAssetsShare_Exception_Fail")
    # mcs_failed_increment("ws_PreviewModalMultiAssetsShare")
    # $browser.refresh()
    $browser.goto $envHome
  # end
end

def ws_PreviewModalDownload()
  begin
    ws_GoToWorkspace('My Workspace')
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'open-preview').when_present.click
    $browser.li(:class, 'trigger-download').i(:class, 'icon-download').when_present.click
    ci_ScreenCapture("ws_PreviewModalDownload_Exception_Fail")
    mcs_assertElementPresent('Ci Workspace Preview Modal Trigger Download Test', 'li', 'class', 'trigger-download')
    sleep 9
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
  rescue 
    ci_ScreenCapture("ws_PreviewModalDownload_Exception_Fail")
    mcs_failed_increment("ws_PreviewModalDownload")
    $browser.refresh()
  end
end

def ws_PreviewModalMetaDataTab()
  # begin
    ws_GoToWorkspace('My Workspace')
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'open-preview').when_present.click
    $browser.div(:class, 'preview-data').ul(:class, 'tabs').li(:id, 'preview-metadata').link(:text, 'Metadata').when_present.click
    $browser.p(:text, 'Frames Per Second').wait_until_present
    ci_ScreenCapture("ws_PreviewModalMetaDataTextValues")
    mcs_assertion('RUNTIME', 'MetaData Runtime field text test', 'p', 'text', 'Runtime')
    mcs_assertion('00:01:00', 'MetaData Runtime value text test', 'h4', 'text', '00:01:00') 
    # mcs_assertion('BITRATE', 'MetaData Bitrate field text test', 'p', 'text', 'Bitrate')
    # mcs_assertion('430', 'MetaData Bitrate value text test', 'h4', 'text', '430')
    mcs_assertion('WIDTH', 'MetaData Width field text test', 'p', 'text', 'Width')
    mcs_assertion('480', 'MetaData Width value text test', 'h4', 'text', '480')
    mcs_assertion('HEIGHT', 'MetaData height field text test', 'p', 'text', 'Height')
    mcs_assertion('270', 'MetaData height value text test', 'h4', 'text', '270')
    mcs_assertion('VIDEO CODEC', 'MetaData Video Codec field text test', 'p', 'text', 'Video Codec')
    mcs_assertion('h264', 'MetaData Video Codec value text test', 'h4', 'text', 'h264')
    mcs_assertion('VIDEO BITRATE', 'MetaData Video Bitrate field text test', 'p', 'text', 'Video Bitrate')
    # if $isTestingTeamsite
      # mcs_assertion('341246 bit/s', 'MetaData Video Bitrate value text test', 'h4', 'text', '341246 bit/s')
    # else
      mcs_assertion('341 kb/s', 'MetaData Video Bitrate value text test', 'h4', 'text', '341 kb/s')
    # end
    mcs_assertion('FRAMES PER SECOND', 'MetaData Frames Per Second field text test', 'p', 'text', 'Frames Per Second')
    mcs_assertion('23.98', 'MetaData Frames Per Second value text test', 'h4', 'text', '23.98')
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh() 
  # rescue 
    # ci_ScreenCapture("ws_PreviewModalMetaDataTab_Exception_Fail")
    # mcs_failed_increment("ws_PreviewModalMetaDataTab")
    # $browser.refresh()
  # end
end

def ws_PreviewModalMetaDataImageFileType()
    $browser.span(:text, 'Brazil.png').when_present.click
    $browser.link(:class, 'open-preview').when_present.click
    ci_ScreenCapture("ws_PreviewModalMetaDataImageFileType")
    mcs_assertion('FORMAT', 'MetaData Image File Format Field Title for the image file', 'p', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/p')
    mcs_assertion('png', 'MetaData File Type Value for the image file', 'h4', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/h4')
    mcs_assertion('45 KB', 'MetaData File Size Value for the image file', 'span', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/h4/span') 
    mcs_assertion('RESOLUTION', 'MetaData Resolution Title', 'p', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[4]/p')
    mcs_assertion('256x256', 'MetaData Resolution Value for the image file', 'h4', 'text', '256x256')
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
end

def ws_CloudDownloading()
  # begin
    ws_GoToWorkspace('My Workspace')
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    ci_ScreenCapture("ws_CloudDownloadingIconTest")
    mcs_assertElementPresent('Cloud Download Icon Exists on Workspace Home page', 'link', 'class', 'trigger-download')
    $browser.link(:class, 'trigger-download').when_present.click
    sleep 20
    # $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    # $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.refresh()
  # rescue 
    # ci_ScreenCapture("ws_CloudDownloading_Exception_Fail")
    # mcs_failed_increment("ws_CloudDownloading")
    # $browser.refresh()
  # end
end

def ws_Starring()
  begin
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'trigger-star').when_present.click
    ws_OpenNavigator()
    $browser.li(:id, 'trigger-starred').link(:text, 'Starred').when_present.click
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    ci_ScreenCapture("StarAnAssetTest")
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Ci Workspace Starring Assets test', 'span', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    #unstarred it so that it can be used for next test 
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.link(:class, 'trigger-star').when_present.click
    ws_CloseNavigator()
  rescue 
    ci_ScreenCapture("ws_Starring_Exception_Fail")
    mcs_failed_increment("ws_Starring")
    $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    $browser.refresh()
  end 
end

def ws_Trash_And_Restore()
  begin
    $browser.span(:text, 'Brazil.png').when_present.click
    $browser.link(:class, 'trigger-recycle').when_present.click
    #restore the asset so that it can be used for next test
    ws_OpenNavigator()
    $browser.li(:id, 'trigger-recycle').link(:text, 'Recycle Bin').when_present.click
    $browser.span(:text, 'Brazil.png').wait_until_present
    ci_ScreenCapture("DeleteAnAssetTest")  
    mcs_assertion('Brazil.png', 'Ci Workspace Delete Assets test', 'span', 'text', 'Brazil.png')
    $browser.span(:text,'Brazil.png').when_present.click
    $browser.link(:class, 'trigger-restore').when_present.click
    $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    ws_CloseNavigator()
    $browser.refresh()
    $browser.span(:text, 'Brazil.png').wait_until_present
    ci_ScreenCapture("RestoreDeletedAssetTest")
    mcs_assertion('Brazil.png', 'Ci Workspace Restore Deleted Assets test', 'span', 'text', 'Brazil.png')
  rescue 
    ci_ScreenCapture("ws_Trash_And_Restore_Exception_Fail")
    mcs_failed_increment("ws_Trash_And_Restore")
    $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    $browser.refresh()
  end
end

def ws_Audio_Review_MultipleFiles()
  $browser.img(:xpath, "//img[contains(@alt,'SPIDERMAN_140512_Xu.mov')]").when_present.click
  $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').parent.div.when_present.click
  expand_app_tools = $browser.link(:id, 'open-tools')
  if expand_app_tools.exist? && expand_app_tools.visible?
    expand_app_tools.when_present.click 
  end
  $browser.img(:src, '/img/audio-review.jpg').wait_until_present
  ci_ScreenCapture("ws_Audio_Review_Add_Participants_Open_Tools")
  mcs_assertElementPresent('Audio Review Open Tools Audio Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
  $browser.img(:src, '/img/audio-review.jpg').when_present.click
  $browser.i(:class, 'icon-modal-x').when_present.click
  $browser.img(:xpath, "//img[contains(@alt,'SPIDERMAN_140512_Xu.mov')]").when_present.click
end

def ws_Audio_Review_Add_Participants()  #blocked for now.  webdriver can not locate the element
  # begin
    participantEmail = 'setpwd@yopmail.com'
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    expand_app_tools = $browser.link(:id, 'open-tools')
    if expand_app_tools.exist? && expand_app_tools.visible?
      expand_app_tools.when_present.click 
    end
    $browser.img(:src, '/img/audio-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Audio_Review_Add_Participants_Open_Tools")
    mcs_assertElementPresent('Audio Review Open Tools Audio Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/audio-review.jpg').when_present.click
    $browser.text_field(:class, 'session-input add-participant ui-autocomplete-input').when_present.set participantEmail
    $browser.send_keys :enter
    ci_ScreenCapture("ws_Audio_Review_Add_Participants_Email")
    mcs_assertion(participantEmail, 'Audio Review Add a Participant Email Test', 'li', 'xpath', "//li[contains(@data-id, 'setpwd@yopmail.com')]")
    mcs_assertion('Start a Audio Review Session', 'Start a Audio Review Session h1 text Test', 'h1', 'text', 'Start a Audio Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    mcs_assertElementPresent('Default Image for Related Sessions is Present Test', 'img', 'xpath', '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[2]/div[1]/img')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  # rescue 
    # ci_ScreenCapture("ws_Audio_Review_Add_Participants_Exception_Fail")
    # mcs_failed_increment("ws_Audio_Review_Add_Participants")
  # end 
end

def ws_Audio_Review_SessionName()
  # begin
    $browser.img(:src, '/img/audio-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Audio_Review_SessionName_Open_Tools")
    mcs_assertElementPresent('Audio Review Open Tools Audio Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/audio-review.jpg').when_present.click 
    testStatus = ($browser.text_field(:class, 'session-input add-session-name').when_present.value.include? 'Audio Review') ? 'Passed' : 'Failed'
    mcs_assertPassed('Default Session Name is generated successfully Test', 'Audio Review', testStatus, 'session-input add-session-name')
    $browser.text_field(:class, 'session-input add-session-name').when_present.set 'Xu Session'
    $browser.h3(:text, 'Session Name').when_present.click
    ci_ScreenCapture("ws_Audio_Review_SessionName")
    mcs_assertion('Start a Audio Review Session', 'Start a Audio Review Session h1 text Test', 'h1', 'text', 'Start a Audio Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  # rescue 
    # ci_ScreenCapture("ws_Audio_Review_SessionName_Exception_Fail")
    # mcs_failed_increment("ws_Audio_Review_SessionName")
  # end
end

def ws_Audio_Review_RelatedSession()
  # begin
    $browser.img(:src, '/img/audio-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Audio_Review_SessionName_Open_Tools")
    mcs_assertElementPresent('Audio Review Open Tools Audio Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/audio-review.jpg').when_present.click 
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_Audio_Review_RelatedSession")
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    testStatus1 = ($browser.li(:class, 'heading').div(:class, 'details').when_present.text == 'NAME') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Session Name header Text Test', 'NAME', testStatus1, 'details')
    mcs_assertElementPresent('How many participants Header icon Test', 'i','class','icon-shared-sub')
    testStatus2 = ($browser.li(:class, 'heading').div(:xpath, '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[1]/div[3]').when_present.text == 'GO') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Go To the Saved Related Sessions Test', 'GO', testStatus2, 'action')
    mcs_assertElementPresent('Default Image for Related Sessions is Present Test', 'img', 'xpath', '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[2]/div[1]/img')
    mcs_assertElementPresent('Resume Session Icon is Present Test', 'i', 'class', 'icon-caret-right-bordered')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  # rescue 
    # ci_ScreenCapture("ws_Audio_Review_RelatedSession_Exception_Fail")
    # mcs_failed_increment("ws_Audio_Review_RelatedSession")
  # end
end

def ws_Video_Review_Add_Participants()  #blocked for now.  webdriver can not locate the element
  # begin
    participantEmail = 'setpwd@yopmail.com'
    $browser.img(:src, '/img/video-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Video_Review_Add_Participants_Open_Tools")
    mcs_assertElementPresent('Video Review Open Tools Video Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/video-review.jpg').when_present.click
    $browser.div(:class, 'session-files-buttons').when_present.click
    $browser.text_field(:class, 'add-participant-emails').when_present.set participantEmail
    $browser.send_keys :enter
    ci_ScreenCapture("ws_Video_Review_Add_Participants_Email")
    mcs_assertion(participantEmail, 'Video Review Add a Participant Email Test', 'li', 'xpath', "//li[contains(@data-id, 'setpwd@yopmail.com')]")
    mcs_assertion('Start a Video Review Session', 'Start a Video Review Session h1 text Test', 'h1', 'text', 'Start a Video Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    mcs_assertElementPresent('Default Image for Related Sessions is Present Test', 'img', 'xpath', '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[2]/div[1]/img')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  # rescue 
    # ci_ScreenCapture("ws_Video_Review_Add_Participants_Exception_Fail")
    # mcs_failed_increment("ws_Video_Review_Add_Participants")
  # end 
end

def ws_Video_Review_SessionName()
  begin
    $browser.img(:src, '/img/video-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Video_Review_SessionName_Open_Tools")
    mcs_assertElementPresent('Video Review Open Tools Video Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/video-review.jpg').when_present.click 
    testStatus = ($browser.text_field(:class, 'session-input add-session-name').when_present.value.include? 'Video Review') ? 'Passed' : 'Failed'
    mcs_assertPassed('Default Session Name is generated successfully Test', 'Video Review', testStatus, 'session-input add-session-name')
    $browser.text_field(:class, 'session-input add-session-name').when_present.set 'Xu Session'
    $browser.h3(:text, 'Session Name').when_present.click
    ci_ScreenCapture("ws_Video_Review_SessionName")
    mcs_assertion('Start a Video Review Session', 'Start a Video Review Session h1 text Test', 'h1', 'text', 'Start a Video Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  rescue 
    ci_ScreenCapture("ws_Video_Review_SessionName_Exception_Fail")
    mcs_failed_increment("ws_Video_Review_SessionName")
  end
end

def ws_Video_Review_RelatedSession()
  begin
    $browser.img(:src, '/img/video-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Video_Review_SessionName_Open_Tools")
    mcs_assertElementPresent('Video Review Open Tools Video Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/video-review.jpg').when_present.click 
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_Video_Review_RelatedSession")
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    testStatus1 = ($browser.li(:class, 'heading').div(:class, 'details').when_present.text == 'NAME') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Session Name header Text Test', 'NAME', testStatus1, 'details')
    mcs_assertElementPresent('How many participants Header icon Test', 'i','class','icon-shared-sub')
    testStatus2 = ($browser.li(:class, 'heading').div(:xpath, '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[1]/div[3]').when_present.text == 'GO') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Go To the Saved Related Sessions Test', 'GO', testStatus2, 'action')
    mcs_assertElementPresent('Default Image for Related Sessions is Present Test', 'img', 'xpath', '//*[@id="modal-sessions-1"]/div/div[3]/div[5]/ul/li[2]/div[1]/img')
    mcs_assertElementPresent('Resume Session Icon is Present Test', 'i', 'class', 'icon-caret-right-bordered')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  rescue 
    ci_ScreenCapture("ws_Video_Review_RelatedSession_Exception_Fail")
    mcs_failed_increment("ws_Video_Review_RelatedSession")
  end
end

def ws_RoughCut_SessionName()
  begin
    $browser.img(:src, '/img/roughcut.jpg').wait_until_present
    ci_ScreenCapture("ws_RoughCut_SessionName_Open_Tools")
    mcs_assertElementPresent('RoughCut Open Tools RoughCut Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/roughcut.jpg').when_present.click 
    testStatus = ($browser.text_field(:class, 'session-input add-session-name').when_present.value.include? 'Roughcut') ? 'Passed' : 'Failed'
    mcs_assertPassed('Default Session Name is generated successfully Test', 'Roughcut', testStatus, 'session-input add-session-name')
    $browser.text_field(:class, 'session-input add-session-name').when_present.set 'Xu Session'
    $browser.h3(:text, 'Session Name').when_present.click
    ci_ScreenCapture("ws_RoughCut_SessionName")
    mcs_assertion('Start a Roughcut Session', 'Start a Video Review Session h1 text Test', 'h1', 'text', 'Start a Roughcut Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
  rescue 
    ci_ScreenCapture("ws_RoughCut_SessionName_Exception_Fail")
    mcs_failed_increment("ws_RoughCut_SessionName")
  end
end

def ws_RoughCut_RelatedSession()
  begin
    $browser.img(:src, '/img/roughcut.jpg').wait_until_present
    ci_ScreenCapture("ws_RoughCut_SessionName_Open_Tools")
    mcs_assertElementPresent('RoughCut Open Tools RoughCut Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/roughcut.jpg').when_present.click 
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_RoughCut_RelatedSession")
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    testStatus1 = ($browser.li(:class, 'heading').div(:class, 'details').when_present.text == 'NAME') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Session Name header Text Test', 'NAME', testStatus1, 'details')
    testStatus2 = ($browser.li(:class, 'heading').div(:xpath, '//*[@id="modal-sessions-1"]/div/div[3]/div[4]/ul/li[1]/div[3]').when_present.text == 'GO') ? 'Passed' : 'Failed'
    mcs_assertPassed('Related Sessions Go To the Saved Related Sessions Test', 'GO', testStatus2, 'action')
    mcs_assertElementPresent('Default Image for Related Sessions is Present Test', 'img', 'xpath', '//*[@id="modal-sessions-1"]/div/div[3]/div[4]/ul/li[2]/div[1]/img')
    mcs_assertElementPresent('Resume Session Icon is Present Test', 'i', 'class', 'icon-caret-right-bordered')
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').wait_until_present
    $browser.i(:xpath, '//*[@id="modal-sessions-1"]/div/div[5]/a/i').when_present.click
    $browser.refresh()
  rescue 
    ci_ScreenCapture("ws_RoughCut_RelatedSession_Exception_Fail")
    mcs_failed_increment("ws_RoughCut_RelatedSession")
  end
end

def ws_Audio_Review_StartANewSession()
  # begin
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    expand_app_tools = $browser.link(:id, 'open-tools')
    if expand_app_tools.exist? && expand_app_tools.visible?
      expand_app_tools.when_present.click 
    end
    $browser.img(:src, '/img/audio-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Audio_StartANewSession_Open_Tools")
    mcs_assertElementPresent('Audio Review Open Tools Audio Review Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[3]/a/img')
    $browser.img(:src, '/img/audio-review.jpg').when_present.click
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_Audio_Review_StartANewSession")
    mcs_assertion('Start a Audio Review Session', 'Start an Audio Review Session h1 text Test', 'h1', 'text', 'Start a Audio Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.link(:text, 'Start New Session').when_present.click
    # $browser.element(:css, "a[class='button session create-session']").when_present.click
    $browser.windows.last.use
    $browser.div(:class, 'comments__update').wait_until_present
    # now I found out I can revoke the authorization by going to My Account->revoke so the auth page will show up again
    # ci_ScreenCapture("AudioReviewAuthorizationPageTest")
    # mcs_assertion('Authorization', 'Ci Workspace Audio Review Authorization header1 text test', 'h1', 'text', 'Authorization')
    # mcs_assertion('CFP Application Suite', 'Ci Workspace Audio Review CFP Application Suite header3 text test', 'h1', 'text', 'CFP Application Suite')
    # mcs_assertion('This application will be allowed to perform the following activities with your Ci account:', 'Ci Workspace Audio Review paragraph text test1', 'p', 'text', 'This application will be allowed to perform the following activities with your Ci account:')
    # mcs_assertion('Upload Files', 'Ci Workspace Audio Review list text test1', 'li', 'text', 'Upload Files')
    # mcs_assertion('Download Files', 'Ci Workspace Audio Review list text test2', 'li', 'text', 'Download Files')
    # mcs_assertion('Retrieve File Metadata', 'Ci Workspace Audio Review list text test3', 'li', 'text', 'Retrieve File Metadata')
    # mcs_assertion('CFP Application Suite and Ci will use this information in accordance with the respective terms of service and privacy policy.', 'Ci Workspace Audio Review paragraph text test2','p','text','CFP Application Suite and Ci will use this information in accordance with the respective terms of service and privacy policy.')
    # $browser.button(:id, 'allow-button').when_present.click
    ci_ScreenCapture("AudioReviewInCFPTest")
    mcs_assertion('Ci', 'Ci Workspace Audio Review CFP Sony Logo Test', 'h1', 'class', 'topper__logo')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Ci Workspace Audio Review CFP File Name Test', 'div', 'class', 'waveform__title')
    mcs_assertion('Feedback', 'Ci Workspace Audio Review CFP Feedback link text Test', 'link', 'class', 'header_link')
    mcs_assertion('Logout', 'Ci Workspace Audio Review CFP Logout link text Test', 'link','text', 'Logout')
    mcs_assertion('Update comments', 'Ci Workspace Audio Review CFP Update Comments text test', 'div', 'class', 'comments__update')
    $browser.windows.last.close
    $browser.windows.last.use
  # rescue 
    # ci_ScreenCapture("ws_Audio_Review_Exception_Fail")
    # $browser.windows.last.close
    # $browser.windows.last.use
    # mcs_failed_increment("ws_Audio_Review")
  # end
end

def ws_Video_Review_StartANewSession()
  begin
    $browser.img(:src, '/img/video-review.jpg').wait_until_present
    ci_ScreenCapture("ws_Video_StartANewSession_Open_Tools")
    mcs_assertElementPresent('Video Review Open Tools Video Review Image Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[2]/a/img')
    $browser.img(:src, '/img/video-review.jpg').when_present.click
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_Video_Review_StartANewSession")
    mcs_assertion('Start a Video Review Session', 'Start a Video Review Session h1 text Test', 'h1', 'text', 'Start a Video Review Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.link(:text, 'Start New Session').when_present.click
    $browser.windows.last.use
    $browser.link(:text, 'Logout').wait_until_present
    ci_ScreenCapture("VideoReviewInCFPTest")
    #there is current a bug on the cfp side where it is not showing filename on the top left corner on the page for the following assertion.
    #comment out the following assertion for now until it gets fixed
    # mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi-07cb9858-fc6a-41d2-af67-a0968061a83b', 'Ci Workspace Video Review CFP File Name Test', 'div', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi-07cb9858-fc6a-41d2-af67-a0968061a83b')
    mcs_assertion('Export', 'Ci Workspace Video Review CFP Export link Test', 'li', 'xpath', '/html/body/div[5]/div[2]/nav/ul/li[2]')
    mcs_assertion('Feedback', 'Ci Workspace Video Review CFP Feedback link text Test', 'link', 'class', 'header_link')
    mcs_assertion('Hotkeys', 'Ci Workspace Video Review CFP Hotkeys link text Test', 'link', 'xpath', '/html/body/div[5]/div[2]/nav/ul/li[4]/a')
    mcs_assertion('Logout', 'Ci Workspace Video Review CFP Logout link text Test', 'link','text', 'Logout')
    $browser.windows.last.close
    $browser.windows.last.use
  rescue 
    ci_ScreenCapture("ws_Video_Review_Exception_Fail")
    $browser.windows.last.close
    $browser.windows.last.use
    mcs_failed_increment("ws_Video_Review")
  end 
end

def ws_RoughCut_StartANewSession()
  begin
    $browser.img(:src, '/img/roughcut.jpg').wait_until_present
    ci_ScreenCapture("ws_Roughcut_StartANewSession_Open_Tools")
    mcs_assertElementPresent('Roughcut Open Tools Roughcut Image Element Is Present Test', 'img', 'xpath', '//*[@id="tools"]/div/ul/li[1]/a/img')
    $browser.img(:src, '/img/roughcut.jpg').when_present.click
    $browser.h3(:text, 'Related Sessions').wait_until_present
    ci_ScreenCapture("ws_RoughCut_StartANewSession")
    mcs_assertion('Start a Roughcut Session', 'Start a Roughcut Review Session h1 text Test', 'h1', 'text', 'Start a Roughcut Session')
    mcs_assertion('You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.', \
                  'You are about to ... p tag text Test', 'p', 'text', 'You are about to start a collaborative session for the first time with this file. Remember that you have a limited amount of Sessions per month.')
    mcs_assertion('Session Name', 'Session Name h3 tag text Test', 'h3', 'text', 'Session Name')
    mcs_assertion('Single File', 'Single File h3 tag text Test', 'h3', 'class', 'session-file-info')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi.mp4', 'Single File Name text Test', 'b', 'text', 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4')
    mcs_assertion('OK', 'Single File Ingest Status text Test', 'span', 'class', 'OK')
    # mcs_assertion('Add Participants', 'Add Participants h3 text Test', 'h3', 'text', 'Add Participants')
    mcs_assertion('Start New Session', 'Start New Session button is present Test', 'link', 'text', 'Start New Session')
    mcs_assertion('You Have Unlimited Sessions', 'You Have Unlimited Sessions paragraph tag text Test', 'p', 'text', 'You Have Unlimited Sessions')
    mcs_assertion('Related Sessions', 'Related Sessions h3 tag text Test', 'h3', 'text','Related Sessions')
    $browser.a(:text, 'Start New Session').when_present.click
    $browser.windows.last.use
    $browser.link(:text, 'Logout').wait_until_present
    ci_ScreenCapture("RoughCutInCFPTest")
    mcs_assertion('Sony', 'Ci Workspace RoughCut CFP Sony logo Test', 'h1', 'class', 'topper__logo')
    mcs_assertion('Feedback', 'Ci Workspace RoughCut CFP Feedback link text Test', 'link', 'class', 'header_link')
    mcs_assertion('BOOM_Premiere_Sizzle_v1-proxy-hi-07cb9858-fc6a-41d2-af67-a0968061a83b', 'Ci Workspace RoughCut CFP File Name Title Test', 'div', 'class', 'filename__title')
    mcs_assertion('Logout', 'Ci Workspace RoughCut CFP Logout link text Test', 'link','text', 'Logout')
    $browser.windows.last.close
    $browser.windows.last.use
  rescue 
    ci_ScreenCapture("ws_RoughCut_Exception_Fail")
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').wait_until_present
    $browser.span(:text, 'BOOM_Premiere_Sizzle_v1-proxy-hi.mp4').when_present.click
    $browser.refresh()
    mcs_failed_increment("ws_RoughCut")
  end 
end

def ws_WirelessAdapterClientPreviewOnUpload()
  begin
    if $browser.div(:class, 'span1').link(:id, 'open-navigator').exists?
      $browser.div(:class, 'span1').link(:id, 'open-navigator').when_present.click
    end
    $browser.span(:xpath, "//span[contains(@data-device-id, 'SPPSNSPP2017626')]").when_present.click
    $browser.h1(:text, 'Ci Sample Web Client').wait_until_present
    ci_ScreenCapture("WirelessAdapterClientDeviceTitleTest")
    mcs_assertion('Ci Sample Web Client', 'Ci Wireless Adapter Client->Device Title Test', 'h1', 'id', 'title')
    $browser.div(:class, 'details').span(:text, 'TASM_TVSCRN28_R6_NEW2.jpg').wait_until_present
    $browser.div(:class, 'details').span(:text, 'TASM_TVSCRN28_R6_NEW2.jpg').when_present.click
    $browser.li(:xpath, "//li[contains(@data-original-title, 'Preview')]").link(:class, 'open-preview').when_present.click
    $browser.div(:class, 'preview-screen').wait_until_present
    ci_ScreenCapture("WirelessAdapterClientDeviceUploadPreviewTest")
    mcs_assertion('TASM_TVSCRN28_R6_NEW2.jpg', 'Ci Wireless Adapter Client->Device Preview Upload File Title Test', 'h1', 'text', 'TASM_TVSCRN28_R6_NEW2.jpg')
    mcs_assertElementPresent('Ci Wireless Adapter Client->Device Preview Upload File Player Test', 'div', 'class', 'preview-screen')
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
  rescue 
    ci_ScreenCapture("ws_WirelessAdapterClientPreviewOnUpload_Exception_Fail")
    mcs_failed_increment("ws_WirelessAdapterClientPreviewOnUpload")
  end
end

def ws_ConnectedDeviceEditDeviceNameUnderWorkspace()
  begin
    if $browser.div(:class, 'span1').link(:id, 'open-navigator').exists?
      $browser.div(:class, 'span1').link(:id, 'open-navigator').when_present.click
    end 
    $browser.span(:xpath, "//span[contains(@data-device-id, 'SPPSNSPP2017626')]").when_present.click
    $browser.i(:class, 'icon-edit edit-device-title').when_present.click
    $browser.h1(:xpath, '//*[@id="modal-device-edit"]/div/div[1]/h1').wait_until_present
    ci_ScreenCapture("ConnectedDeviceNameBeforeEditTest")
    mcs_assertion('Ci Sample Web Client', 'Connected Device Before Change Device Name Text Test', 'h1', 'xpath', '//*[@id="modal-device-edit"]/div/div[1]/h1') 
    $browser.text_field(:id, 'deviceName').when_present.set 'Xu Device'
    $browser.link(:id, 'save-device-info').when_present.click
    $browser.span(:text, "Xu Device").wait_until_present
    ci_ScreenCapture("ConnectedDeviceNameAfterEditTest")
    mcs_assertion('XU DEVICE', 'Ci Wireless Adapter After Change Device Name Text Test', 'span', 'xpath', "//span[contains(@data-device-id, 'SPPSNSPP2017626')]")
    $browser.i(:class, 'icon-edit edit-device-title').when_present.click
    $browser.link(:id, 'reset-device-info').when_present.click
    $browser.span(:xpath, "//span[contains(@data-device-id, 'SPPSNSPP2017626')]").wait_until_present
    ci_ScreenCapture("ConnectedDeviceNameSetBacktoDefaultTest")
    mcs_assertion('CI SAMPLE WEB CLIENT', 'Connected Device Name Set Back to Default Test', 'span', 'xpath', "//span[contains(@data-device-id, 'SPPSNSPP2017626')]")
    $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
  rescue 
    ci_ScreenCapture("ws_WirelessAdapterClientPreviewOnUpload_Exception_Fail")
    mcs_failed_increment("ws_WirelessAdapterClientPreviewOnUpload")
  end 
end

def ws_WirelessAdapterEditDeviceNameUnderAccountManager()
  begin
    if $browser.div(:class, 'span1').link(:id, 'open-navigator').exists?
      $browser.div(:class, 'span1').link(:id, 'open-navigator').when_present.click
    end
    $browser.link(:xpath, '//*[@id="_connectedDevices"]/div/h4/a').i(:class, 'icon-caret-right align-right').when_present.click
    $browser.h3(:text, 'Devices').wait_until_present
    ci_ScreenCapture("WirelessAdapterClient-DeviceListTest")
    mcs_assertion('Devices', 'Ci Wireless Adapter Device Text Test', 'h3', 'text', 'Devices')
    mcs_assertion('Ci Sample Web Client', 'Client Name is present Test', 'span', 'xpath', '//*[@id="account"]/div/div[2]/ul/li/div[1]/p/b/span')
    mcs_assertion('Ci Sample Web Client', 'Device Name is present Test', 'span', 'xpath', '//*[@id="account"]/div/div[2]/ul/li/ul/li/div[1]/p/b/span')
    mcs_assertion('months ago', 'How long Client has been linked Test', 'div', 'class', 'client-created')
    mcs_assertion('months ago', 'How long Device has been linked Test', 'div', 'class', 'device-created')
    mcs_assertion('months ago', 'How long Device Last Used Test', 'div', 'class', 'device-modified')
    mcs_assertElementPresent('Client RSS Icon is present test', 'i', 'class', 'icon-rss')
    mcs_assertElementPresent('Device Icon is present test', 'i', 'class', 'icon-connected-device')
    $browser.div(:class, 'device-edit').i(:class, 'icon-edit').when_present.click
    ci_ScreenCapture("WirelessAdapterDeviceNameBeforeEditTest")
    mcs_assertion('Ci Sample Web Client', 'Ci Wireless Adapter Before Change Device Name Text Test', 'h1', 'text', 'Ci Sample Web Client') 
    $browser.text_field(:id, 'deviceName').when_present.set 'Xu Test Web Client'
    $browser.link(:id, 'save-device-info').when_present.click
    $browser.span(:xpath, "//span[contains(@data-device-id, 'SPPSNSPP2017626')]").wait_until_present
    ci_ScreenCapture("WirelessAdapterDeviceNameAfterEditTest")
    mcs_assertion('Xu Test Web Client', 'Ci Wireless Adapter After Change Device Name Text Test', 'span', 'xpath', "//span[contains(@data-device-id, 'SPPSNSPP2017626')]")
    $browser.div(:class, 'device-edit').i(:class, 'icon-edit').when_present.click
    $browser.link(:id, 'reset-device-info').when_present.click 
    ci_ScreenCapture("WirelessAdapterDeviceNameSetBacktoDefaultTest")
    mcs_assertion('Ci Sample Web Client', 'Ci Wireless Adapter Device Name Set Back to Default Test', 'h1', 'text', 'Ci Sample Web Client') 
    $browser.div(:class, 'done to-workspace').i(:class, 'icon-modal-x').when_present.click
    ci_ScreenCapture('ConnectedDevicesEditDeviceNameDonebuttonBacktoWorkspace')
    testStatus = ($browser.h1(:id, 'title').span(:text, 'Workspace').when_present.text.include? 'Workspace') ? 'Passed' : 'Failed'
    mcs_assertPassed('Connected Device Done button back to Workspace Test', 'Workspace', testStatus, 'text')
  rescue 
    ci_ScreenCapture("ws_WirelessAdapterEditDeviceNameUnderAccountManager_Exception_Fail")
    mcs_failed_increment("ws_WirelessAdapterEditDeviceNameUnderAccountManager")
    $browser.div(:class, 'done to-workspace').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
  end
end

def ws_WirelessAdapterUnlinkDevice()
  begin
    if $browser.div(:class, 'span1').link(:id, 'open-navigator').exists?
      $browser.div(:class, 'span1').link(:id, 'open-navigator').when_present.click
    end
    $browser.link(:xpath, '//*[@id="_connectedDevices"]/div/h4/a').i(:class, 'icon-caret-right align-right').when_present.click
    $browser.link(:text, 'Unlink').when_present.click
    ci_ScreenCapture("WirelessAdapterUnlinkDeviceTest")
    mcs_assertion('Unlink Device', 'Ci Wireless Adapter Unlink Device Page Title Text Test', 'h1', 'xpath', '//*[@id="modal-client-unlink"]/div/div[1]/h1')
    mcs_assertion('Unlinking this client will remove its folders and files from Ci. Proceed to unlink device?', 'Ci Wireless Adapter Unlink Device Page Confirmation Text Test', 'p', 'xpath', '//*[@id="modal-client-unlink"]/div/div[1]/p')
    mcs_assertion('Unlink and Keep Files', 'Ci Wireless Adapter Unlink Device Page Unlink and Keep Files button Presents Test', 'link', 'id', 'client-unlink-keep')
    mcs_assertion('Unlink and Remove Files', 'Ci Wireless Adapter Unlink Device Page Unlink and Remove Files button Presents Test', 'link', 'id', 'client-unlink-remove')
    mcs_assertion('Cancel', 'Ci Wireless Adapter Unlink Device Page Cancel button Presents Test', 'link', 'id', 'client-unlink-cancel')  
    $browser.link(:id, 'client-unlink-cancel').when_present.click
    $browser.div(:class, 'done to-workspace').i(:class, 'icon-modal-x').when_present.click
    ci_ScreenCapture('ConnectedDevicesEditDeviceNameDonebuttonBacktoWorkspace')
    testStatus = ($browser.h1(:id, 'title').span(:text, 'Workspace').when_present.text.include? 'Workspace') ? 'Passed' : 'Failed'
    mcs_assertPassed('Connected Device Done button back to Workspace Test', 'Workspace', testStatus, 'text')
    $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    $browser.refresh()
  rescue 
    ci_ScreenCapture("ws_WirelessAdapterUnlinkDevice_Exception_Fail")
    mcs_failed_increment("ws_WirelessAdapterUnlinkDevice")
    $browser.div(:class, 'done to-workspace').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
  end
end

#Recent upload page
def ws_RecentUpload(image)
  # begin
    #Upload a new image
    # ws_GoToWorkspace('My Workspace')
    assetUploadFilePath = Dir.pwd + "/input/assets/#{image}"
    $browser.file_field(:id, 'selected-files').set assetUploadFilePath
    sleep(4)
    ci_ScreenCapture("UploadTest")
    mcs_assertion("#{image}", 'Ci Workspace Upload test', 'span', 'xpath', '//*[@id="files"]/div/div[4]/div[1]/div[2]/span[1]')
    helper_Wait_Until_Ready()
    sleep(10)
    ws_OpenNavigator()
    # expand_navigator = $browser.link(:id => 'open-navigator')
    # if expand_navigator.exist? && expand_navigator.visible?
      # expand_navigator.click 
    # end
    
    # Verify image on recent upload page
    $browser.div(:class => 'subpanel uploads').link(:text => 'Recent Uploads').when_present.click
    mcs_assertion("#{image}", 'WS - Verify image comes under recent upload folder', 'div', 'class', 'details')
    sleep(3)
    # Share image on recent upload page
    $browser.span(:text, "#{image}").when_present.click
    ws_ClickSendToEmail()
    # $browser.link(:class, 'open-share').when_present.click
    $browser.text_field(:id, 'share-subject').when_present.set 'Test Share subject by automation'
    $browser.textarea(:id, 'share-message').when_present.set 'Test Share message by automation'
    $browser.text_field(:id, 'share-recipients').when_present.set 'ciworkspacesharingtest@yopmail.com'
    $browser.checkbox(:id, 'share-allow-download').when_present.set
    $browser.select_list(:id,'share-ttl').when_present.select('One Month')
    $browser.button(:text, 'Share').when_present.click
    ci_ScreenCapture("FileShareTest")
    mcs_assertion('Your file has been shared', 'Ci Workspace Share test on recent upload page', 'p', 'text', 'Your file has been shared')
    $browser.refresh()
    $browser.div(:class => 'subpanel uploads').link(:text => 'Recent Uploads').when_present.click
    
    # Download on recent upload page
    $browser.span(:text, "#{image}").when_present.click
    $browser.link(:class, 'open-preview').when_present.click
    $browser.li(:class, 'trigger-download').i(:class, 'icon-download').when_present.click
    ci_ScreenCapture("ws_PreviewModalDownload_Exception_Fail")
    mcs_assertElementPresent('Ci Workspace download on recent upload page', 'li', 'class', 'trigger-download')
    sleep(9)
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
    $browser.div(:class => 'subpanel uploads').link(:text => 'Recent Uploads').when_present.click
    
    #Mark star image on recent upload page
    $browser.span(:text, "#{image}").when_present.click
    $browser.link(:class, 'open-preview').when_present.click 
    $browser.li(:xpath, '//*[@class="preview-action"]/li[1]').i(:class, 'icon-star-filled toggle-star').when_present.click
    ci_ScreenCapture("PreviewModalStarTest")
    mcs_assertElementPresent('Ci Workspace mark star on recent upload page', 'li', 'class', 'starred')
    #click the star icon again to unstar it so that it will be ready for the next test
    $browser.li(:xpath, '//*[@class="preview-action"]/li[1]').i(:class, 'icon-star-filled toggle-star').when_present.click 
    $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
    $browser.refresh()
    $browser.div(:class => 'subpanel uploads').link(:text => 'Recent Uploads').when_present.click
    
    #Delete
    $browser.span(:text, "#{image}").when_present.click
    $browser.link(:class => 'trigger-recycle').when_present.click
    $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    ws_CloseNavigator()
    # $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    $browser.refresh()
    sleep(4)
    
  # rescue
    # ci_ScreenCapture("ws_RecentUpload_Exception_Fail")
    # mcs_failed_increment("ws_RecentUpload")
    # $browser.li(:class, "drop-folder folder ui-droppable").link(:text, "Workspace").when_present.click
    # $browser.div(:class, 'span3').div(:class, 'panel span3').div(:class, 'close').link(:id, 'close-navigator').when_present.click
    # $browser.refresh()
  # end
end

def ws_FileInfoOnPreviewModal(filename, waittime, filetype, filesize, fileresolution)
  uploadFilePath = Dir.pwd + "/input/assets/#{filename}"
  $browser.file_field(:id, 'selected-files').set uploadFilePath
  helper_Wait_Until_Ready()
  sleep(waittime)
  $browser.span(:text, "#{filename}").when_present.click
  $browser.link(:class, 'open-preview').when_present.click
  $browser.p(:xpath, '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/p').wait_until_present
  ci_ScreenCapture("ws_FileInfoOnPreviewModalFileType#{filetype}")
  mcs_assertion(filetype, "#{filetype} File Type Value", 'h4', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/h4')
  mcs_assertion(filesize, "#{filetype} File Size Value", 'span', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[3]/h4/span')
  if (!(filetype == 'wav' || filetype == 'avi' || filetype == 'mp3'))
    mcs_assertion(fileresolution, "#{filetype} Resolution Value", 'h4', 'xpath', '//*[@id="modal-preview"]/div[3]/div[2]/div[1]/div[4]/h4')
  end
  $browser.div(:id, 'modal-preview').div(:id, 'close-modal').i(:class, 'icon-modal-x').when_present.click
  $browser.refresh()
  $browser.span(:text, "#{filename}").when_present.click
  $browser.link(:class => 'trigger-recycle').when_present.click
  $browser.refresh()
end

#Verify fields given on preview page
def ws_VerifyPreviewModel(image)
  # begin
    user_name = $browser.link(:class => 'dropdown-toggle').text
    image_size = File.size(Dir.pwd + "/input/assets/#{image}")/1024
    image_format =  image.split('.')[1]
    #~ #Upload image
    assetUploadFilePath = Dir.pwd + "/input/assets/#{image}"
    $browser.file_field(:id, 'selected-files').set assetUploadFilePath
    helper_Wait_Until_Ready()
    sleep(5)
    $browser.link(:class, 'open-preview').when_present.click
    ci_ScreenCapture("ws_VerifyPreviewModel")
    mcs_assertion("#{user_name}", 'Verify uploaded by field on Preview model', 'div', 'class', 'preview-data')
    mcs_assertion("#{image_size}", 'Verify file size field on Preview model', 'div', 'class', 'preview-data')
    mcs_assertion("#{image_format}" , 'Verify image format field on Preview model', 'div', 'class', 'preview-data')
    uploaded_on_match = $browser.div(:class => 'panel info').text.scan(/minutes ago|minute ago|hour ago|hours ago|yesterday/).to_s
    mcs_assertion("#{uploaded_on_match}" , 'Verify uploaded on field on Preview model', 'div', 'class', 'preview-data')
    $browser.refresh
    #delete the test image
    $browser.div(:class, 'details').span(:text, "#{image}").when_present.click
    $browser.link(:class => 'trigger-recycle').when_present.click
    $browser.refresh()
  # rescue
    # ci_ScreenCapture("ws_VerifyPreviewModel_Exception_Fail")
    # mcs_failed_increment("ws_VerifyPreviewModel")
  # end
end

#Verify file count in recent & workspace page & compare with uesername header file count
def ws_VerifyUserNameHeader()
  begin
    no_of_images_on_recycle_bin = 0
    no_of_images_on_workspace = 0
    expand_navigator = $browser.link(:id => 'open-navigator')
    ws_OpenNavigator()
    thumbnail = $browser.div(:class => 'thumbnails')
    #Count images on workspace page
    $browser.div(:class => 'subpanel uploads').link(:text => 'Workspace').when_present.click
    $browser.wait_until {$browser.span(:text => 'Workspace').exist?}
    sleep(5)
    if thumbnail.exist?
      no_of_images_on_workspace = $browser.divs(:class => 'thumbnails').length 
    end
    #Count images on recycle bin page
    $browser.div(:class => 'subpanel uploads').link(:text => 'Recycle Bin').when_present.click
    $browser.wait_until {$browser.span(:text => 'Recycle Bin').exist?}
    sleep(5)
    if thumbnail.exist?
      no_of_images_on_recycle_bin = $browser.divs(:class => 'thumbnails').length 
    end
    #Calculate total file size
    total_images_count = no_of_images_on_recycle_bin + no_of_images_on_workspace
    if $isTestingTeamsite
      $browser.li(:id, 'user-profile-menu').link(:class, 'dropdown-toggle').when_present.click
    else
      $browser.link(:class => 'dropdown-toggle').when_present.click
    end
    #Verify storage static text
    mcs_assertion('MB of 5 GB' , 'Verify Storage Space displays on username dropdown header', 'div', 'class', 'usage-space')
    #Verify count of image under workspace & recycle bin
    mcs_assertion("#{total_images_count} Files" , 'Verify files count displays on username dropdown header', 'div', 'class', 'usage-files')
    #verify manage acount link on username dropdown header
    mcs_assertion("Manage Account" , 'Verify manage account link displays on username dropdown header', 'ul', 'class', 'dropdown-menu')
  rescue
    ci_ScreenCapture("ws_VerifyUserNameHeader_Exception_Fail")
    mcs_failed_increment("ws_VerifyUserNameHeader")
  end
end

def ws_VerifyAccountManagerPage()
  begin
    user_name = $browser.li(:class => 'dropdown user').link(:class => 'dropdown-toggle').text
    $browser.link(:class => 'dropdown-toggle').when_present.click if not $browser.li(:class => 'dropdown user open').exist?
    mcs_assertion("Manage Account" , 'Verify manage account link displays on username dropdown header', 'ul', 'class', 'dropdown-menu')
    $browser.link(:text => 'Manage Account').when_present.click
    #Profile page
    mcs_assertion("Account Manager" , 'Verify heading of Account manager page', 'div', 'class', 'account')
    mcs_assertion("#{user_name}" , 'Verify username on Account manager page', 'div', 'class', 'account')
    mcs_assertion("#{$email}" , 'Verify email on Account manager page', 'div', 'class', 'account')
    mcs_assertion("5 GB" , 'Verify total space on Account manager page', 'div', 'class', 'account')
    mcs_assertion("Total Storage" , 'Verify total storage text on Account manager page', 'div', 'class', 'account')
    mcs_assertion("Standard Account" , 'Verify account type on Account manager page', 'p', 'class', 'account')
    mcs_assertion("Done" , 'Verify Done button on Account manager page', 'div', 'text', 'Done')
    # Manage plan Page
    $browser.link(:text => 'Manage Plan').when_present.click
    $browser.wait_until {$browser.h3(:text => 'Total Storage').exist?}
    mcs_assertion("5 GB" , 'Verify total space on Account manager page', 'div', 'class', 'account')
    mcs_assertion("Standard" , 'Verify standard plan on Account manager page', 'h4', 'text', 'Standard')
    mcs_assertion("Pro" , 'Verify pro plan on Account manager page', 'h4', 'text', 'Pro')
    mcs_assertion("Pro+" , 'Verify pro+ plan on Account manager page', 'h4', 'text', 'Pro+')
    mcs_assertion("Current Plan" , 'Verify pro+ plan on Account manager page', 'div', 'text', 'Current Plan')
    mcs_assertion("Contact Us" , 'Verify contact us link on Account manager page', 'link', 'text', 'Contact Us')
  rescue
    ci_ScreenCapture("ws_VerifyAccountManagerPage_Exception_Fail")
    mcs_failed_increment("ws_VerifyAccountManagerPage")
  end
end

def ws_VerifyHelpHeader()
  begin
    $browser.li(:class => 'dropdown help').link(:class => 'dropdown-toggle').when_present.click
    mcs_assertion("Help", 'Verify help link under question mark header', 'ul', 'class', 'nav')
    mcs_assertion("Contact Support", 'Verify Contact Support link under question mark header', 'ul', 'class', 'nav')
    mcs_assertion("Terms of Service", 'Verify Terms of Service link under question mark header', 'ul', 'class', 'nav')
    mcs_assertion("Privacy Policy", 'Verify Privacy Policy link under question mark header', 'ul', 'class', 'nav')
    mcs_assertion("Acceptable Use", 'Verify Acceptable Use link under question mark header', 'ul', 'class', 'nav')
    mcs_assertion("Sony", 'Verify Privacy Policy link under question mark header', 'li', 'class', 'nav')
    $browser.li(:class => 'dropdown help').link(:class => 'dropdown-toggle').when_present.click
    $browser.div(:class, 'done to-workspace').i(:class, 'icon-modal-x').when_present.click
  rescue
    ci_ScreenCapture("ws_VerifyHelpHeader_Exception_Fail")
    mcs_failed_increment("ws_VerifyHelpHeader")
  end
end

def ws_VerifyFooterLinks()
  # begin
    ci_ScreenCapture('WS_FooterLinksBeforeLogin')
    mcs_assertion('PRIVACY', 'WS Footer Links Before Login Privacy Link Presents Test', 'link', 'text', 'Privacy')
    mcs_assertion('TERMS', 'WS Footer Links Before Login Terms of Use Link Presents Test', 'link', 'text', 'Terms')
    mcs_assertion('ACCEPTABLE USE', 'WS Footer Links Before Login Acceptable Use Link Presents Test', 'link', 'text', 'Acceptable Use')
    mcs_assertion('FAQ', 'WS Footer Links Before Login Help Link Presents Test', 'link', 'text', 'FAQ')
    mcs_assertion('2013 SONY MEDIA CLOUD SERVICES LLC. A GLOBAL COMPANY.', 'WS Footer CopyRight Text Test', 'p', 'xpath', '/html/body/div[2]/div[2]/p')
    $browser.link(:text, 'Terms').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('WS_TermsofUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS', 'WS Footer Terms & Conditions Page Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES TERMS & CONDITIONS')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'Privacy').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('WS_PrivacyPolicyPage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES PRIVACY POLICY', 'WS Footer Privacy Policy Page Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES PRIVACY POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'Acceptable Use').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('WS_AcceptableUsePage')
    mcs_assertion('SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY', 'WS Footer Acceptable Use Page Text Test', 'h1', 'text', 'SONY MEDIA CLOUD SERVICES ACCEPTABLE USE POLICY')
    $browser.windows.last.close
    $browser.windows.last.use
    $browser.link(:text, 'FAQ').when_present.click
    $browser.windows.last.use
    ci_ScreenCapture('WS_FAQPage')
    mcs_assertion('FAQ', 'WS Footer FAQ Page Text Test', 'h1', 'text', 'FAQ')
    $browser.windows.last.close
    $browser.windows.last.use
  # rescue
    # ci_ScreenCapture("ws_VerifyFooterLinks_Exception_Fail")
    # mcs_failed_increment("ws_VerifyFooterLinks")
  # end  
end


