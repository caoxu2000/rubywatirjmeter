require 'rubygems'
require 'watir-webdriver'
require 'roo'

def assetReadExcel()
  oo = Excelx.new("./input/assets.xlsx")
  oo.default_sheet = oo.sheets.first
  2.upto(50) do |line|
    $assetName    = oo.cell(line,'A')   
  end 
end

def browserReadExcel()
  oo = Excelx.new("./input/browser.xlsx")
  oo.default_sheet = oo.sheets.first
  3.upto(3) do |line|
    $browser       = oo.cell(line,'B')
  end 
end

def loginReadExcel
  oo = Excelx.new("./input/logins.xlsx")
  oo.default_sheet = oo.sheets.first
  6.upto(6) do |line|
    $userName      = oo.cell(line,'A')
    $password      = oo.cell(line,'B')
    $firstName     = oo.cell(line,'C')
    $lastName      = oo.cell(line,'D')
  end  
end

def envReadExcel(whichApp, whichEnv)
  oo = Excelx.new("./input/env.xlsx")
  if whichApp == 'MB'
    case whichEnv 
      when 'Dev'
        $rowNum = 2
      when 'QA'
        $rowNum = 3
      when 'Stage'
        $rowNum = 4
      when 'Prod'
        $rowNum = 5
      else
        $rowNum = 3 #default to MB QA
      end
  elsif (whichApp == 'WS')
    case whichEnv
      when 'Teams'
        $rowNum = 10
      when 'Dev'
        $rowNum = 6
      when 'QA'
        $rowNum = 7
      when 'Stage'
        $rowNum = 8
      when 'Prod'
        $rowNum = 9
      else
        $rowNum = 7 #default to WS QA
      end
  elsif (whichApp == 'Aria')
    $rowNum = 11 # Aria Stage Env
  else
    $rowNum = 3 #default to MB QA
  end
  oo.default_sheet = oo.sheets.first
  $rowNum.upto($rowNum) do |line|
    $appAndEnv  = oo.cell(line,'A')
    $envURL   = oo.cell(line,'B')
    $envHome  = oo.cell(line,'C')
  end  
end

def apiReadExcel
  oo = Excelx.new("./input/apis.xlsx")
  oo.default_sheet = oo.sheets.first
  2.upto(11) do |line|
    $apiName      = oo.cell(line,'A')
    $apiMethod    = oo.cell(line,'B')
    $apiPath      = oo.cell(line,'C')
    $apiRequest   = oo.cell(line,'D')
    $apiHeader    = oo.cell(line,'E')
    $apiResponse  = oo.cell(line,'F') 
    call_apis()
  end  
end

def launch_browser()
  run = Time.now
  if $browser.include? "firefox"
      puts "FireFox Run: #{$activeTest} :: #{run}"  
      $browser = Watir::Browser.new(:firefox)
  elsif $browser.include? "ie"
      $browser = Watir::Browser.new(:ie)
      puts "\nIE Run: #{$activeTest} :: #{run}"        
  elsif $browser.include? "chrome"
      $browser = Watir::Browser.new(:chrome)
      puts "\nChrome Run: #{$activeTest} :: #{run}"            
  elsif $browser.include? "safari"
      $browser = Watir::Browser.new(:safari)    
      puts "\nSafari Run: #{$activeTest} :: #{run}"        
  end
  $browser.goto $envURL
  $browser.window.move_to(0, 0)
  $browser.window.resize_to(1600, 1200)
end

def mcs_StatusreadExcel()
  oo = Excelx.new("./input/status.xlsx") 
  oo.default_sheet = oo.sheets.first
  3.upto(3) do |line| 
    $CompletedStatus        = oo.cell(line,'A')
    $FailedStatus           = oo.cell(line,'B')
    $InProgressStatus       = oo.cell(line,'C')
    $AnyStatus              = oo.cell(line,'D')
  end  
end

def mcs_ExportreadExcel()
  oo = Excelx.new("./input/export.xlsx") 
  oo.default_sheet = oo.sheets.first
  3.upto(7) do |line| 
    $ExportImageFile        = oo.cell(line,'A')
    $ExportVideoFile        = oo.cell(line,'B')
    $ExportEmailMessage     = oo.cell(line,'C')
    $ExportSendPreview      = oo.cell(line,'D')
    $ExportUsername         = oo.cell(line,'E')
    $ExportIsLoginRequired  = oo.cell(line,'F')
    $ExportEmailActiveDays  = oo.cell(line,'G')
    $ExportEmailActiveHours = oo.cell(line,'H')
    $ExportType             = oo.cell(line,'I')
    $ExportIChzn            = oo.cell(line,'J')
    $ExportVChzn            = oo.cell(line,'K')  
    $JPEGN                  = oo.cell(101,'B')
    $JPEG1                  = oo.cell(102,'A')
    $JPEG2                  = oo.cell(102,'B')
    $JPEG3                  = oo.cell(102,'C')
    $JPEG4                  = oo.cell(102,'D')
    $JPEG5                  = oo.cell(102,'E')
    $JPEG6                  = oo.cell(102,'F')
    $JPEG1R                 = oo.cell(103,'A')
    $JPEG2R                 = oo.cell(103,'B')
    $JPEG3R                 = oo.cell(103,'C')
    $JPEG4R                 = oo.cell(103,'D')
    $JPEG5R                 = oo.cell(103,'E')
    $JPEG6R                 = oo.cell(103,'F') 
    $TIFFN                  = oo.cell(106,'B')
    $TIFF1                  = oo.cell(107,'A')
    $TIFF2                  = oo.cell(107,'B')
    $TIFF3                  = oo.cell(107,'C')
    $TIFF1R                 = oo.cell(108,'A')
    $TIFF2R                 = oo.cell(108,'B')
    $TIFF3R                 = oo.cell(108,'C') 
    $PDFN                  = oo.cell(111,'B')
    $PDF1                  = oo.cell(112,'A')    
    $PDF1R                 = oo.cell(113,'A')
    $MOVN                  = oo.cell(116,'B')
    $MOV1                  = oo.cell(117,'A')
    $MOV2                  = oo.cell(117,'B')
    $MOV3                  = oo.cell(117,'C')
    $MOV4                  = oo.cell(117,'D')
    $MOV5                  = oo.cell(117,'E')
    $MOV6                  = oo.cell(117,'F')
    $MOV7                  = oo.cell(117,'G')
    $MOV8                  = oo.cell(117,'H')
    $MOV9                  = oo.cell(117,'I')
    $MOV10                 = oo.cell(117,'J')
    $MOV11                 = oo.cell(117,'K')
    $MOV12                 = oo.cell(117,'L')
    $MOV13                 = oo.cell(117,'M')
    $MOV1R                 = oo.cell(118,'A')
    $MOV2R                 = oo.cell(118,'B')
    $MOV3R                 = oo.cell(118,'C')
    $MOV4R                 = oo.cell(118,'D')
    $MOV5R                 = oo.cell(118,'E')
    $MOV6R                 = oo.cell(118,'F')
    $MOV7R                 = oo.cell(118,'G')
    $MOV8R                 = oo.cell(118,'H')
    $MOV9R                 = oo.cell(118,'I')
    $MOV10R                = oo.cell(118,'J')
    $MOV11R                = oo.cell(118,'K')
    $MOV12R                = oo.cell(118,'L')
    $MOV13R                = oo.cell(118,'M')
    $MP4N                  = oo.cell(121,'B')
    $MP41                  = oo.cell(122,'A')    
    $MP42                  = oo.cell(122,'B') 
    $MP43                  = oo.cell(122,'C') 
    $MP44                  = oo.cell(122,'D') 
    $MP45                  = oo.cell(122,'E') 
    $MP46                  = oo.cell(122,'F') 
    $MP41R                 = oo.cell(123,'A')
    $MP42R                 = oo.cell(123,'B')
    $MP43R                 = oo.cell(123,'C')
    $MP44R                 = oo.cell(123,'D')    
    $MP45R                 = oo.cell(123,'E')    
    $MP46R                 = oo.cell(123,'F')   
  end  
end

#Invalid credentials
def invalidLoginReadExcel
  oo = Excelx.new("./input/logins.xlsx")
  oo.default_sheet = oo.sheets.first
  7.upto(7) do |line|
    $wronguserName      = oo.cell(line,'A')
    $wrongpassword      = oo.cell(line,'B')
  end  
end