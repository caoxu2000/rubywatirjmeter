def writeTestResults(testName, assertion)
  testName = testName
  assertion = assertion
  testStatus = $testStatus
  attribute_value = $attribute_value
  statusColor = (testStatus == 'Passed') ? 'green' : 'red'
  #File.open( "templates/Maruti/HTML/index.html", "a" ) do | testResultHtml |
  File.open( "output/TestResults.htm", "a" ) do | testResultHtml |
    testResultHtml.puts <<EOF
    <h3>#{testName}</h3>
    <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
    <tr valign="top">
    <th>Assertion</th><th>Status</th><th>Attribute Details</th><th>Screen Capture</th><th nowrap>Time(s)</th>
    </tr>
    <tr valign="top" class="">
    <td style="background: #{statusColor}"><strong>#{assertion}</strong></td><td style="background: #{statusColor}"><strong>#{testStatus}</strong></td><td style="background: #{statusColor}"><strong>#{attribute_value} - #{testStatus}</strong></td><td><a href="screenshots/#{$screenCaptureImageFileName}"><img src="screenshots/#{$screenCaptureImageFileName}" width="200" height="115"></a></td><td style="background: #{statusColor}"></td>
    </tr>
    </table> 
EOF
  end
end
 
  
def writeTestResultHtmlHeader()
   File.open( "output/TestResults.htm", "a" ) do | testResultHtml |
   testResultHtml.puts <<EOF
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    <html>
    <head>
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>QA Automation Smoke Test Results</title>
    <style type="text/css">
      body { font-family: verdana,arial,helvetica; color:#000000; font-size: 12px; }
      table tr td, table tr th { font-family: verdana,arial,helvetica; font-size: 12px; }
      table { table-layout: fixed; }
      td { width: 20%; }
      table.details tr th{ font-family: verdana,arial,helvetica; font-weight: bold; text-align:left; background:#a6caf0; }
      table.details tr td{ background:#eeeee0; }
      p { line-height:1.5em; margin-top:0.5em; margin-bottom:1.0em; font-size: 12px; }
      h1 { margin: 0px 0px 5px; font-family: verdana,arial,helvetica; }
      h2 { margin-top: 1em; margin-bottom: 0.5em; font-family: verdana,arial,helvetica; }
      h3 { margin-bottom: 0.5em; font-family: verdana,arial,helvetica; }
      h4 { margin-bottom: 0.5em; font-family: verdana,arial,helvetica; }
      h5 { margin-bottom: 0.5em; font-family: verdana,arial,helvetica; }
      h6 { margin-bottom: 0.5em; font-family: verdana,arial,helvetica; }
      .Error { font-weight:bold; color:red; }
      .Failure { font-weight:bold; color:purple; }
      .small { font-size: 9px; }
      a { color: #003399; }
      a:hover { color: #888888; }
    </style>
    </head>
    <body>
    <a name="top"></a>
    <h1>QA Automation Smoke Test Results - #{$browser} - #{$os} - #{$appAndEnv}</h1>
    <table width="100%">
    <tr>
    <td align="left"></td>
    <td align="right">Designed by MCS QA Team: <a href="https://mcsproject.atlassian.net/wiki/display/MCS/MCS+contact+list">Contact Us</a>
    </td>
    </tr>
    <tr>
    <td align="left"></td><td align="right">
    Smoke Test Suites started at: #{Time.new.inspect}
    </td>
    </tr>
    </table>
EOF
  end
end

def writeSummaryAndOverview()
  $totalTests = ($totalTests == 0) ? 1 : $totalTests 
  successRate =  "%5.2f" % [ (1.0 * $totalPassed) / (1.0 * $totalTests) * 100 ]
  File.open("output/TestResults.htm", "a+") do | testResult |
  testResult.puts <<EOF
  <hr size="1">
  <h2>Failed Tests Report</h2>
  <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
  <tr valign="top">
  <th>Failed test cases</th><th>Time</th>
  </tr>
  <tr valign="top" class="">
  #{$failureName}
  </tr>
  </table>
  <table border="0" width="95%">
  <tr>
  <td style="text-align: justify;">Note: <i>failures</i> are anticipated and checked for with assertions while <i>errors</i> are unanticipated.
  </td>
  </tr>
  </table>
  <hr size="1" width="95%" align="left">
  <h3>Test Report Summary</h3>
  <table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
  <tr valign="top">
  <th>Tests</th><th>Pass</th><th>Failures</th><th>Success rate</th><th>Time</th>
  </tr>
  <tr valign="top" class="" >
  <td>#{$totalTests}</td><td>#{$totalPassed}</td><td>#{$totalFailed}</td><td>#{successRate}%</td><td></td>
  </tr>
  </table>
EOF
  end
end

def writeTestResultHtmlFooter()
 File.open("output/TestResults.htm", "a") do | testResultHtml |
 testResultHtml.puts <<EOF
  <p></p>
  <a href="#top">Back to top</a>
  <table width="100%">
  <tr>
  <td>
  <hr noshade="yes" size="1">
  </td>
  </tr>
  <tr>
  <td class="small"> Report generated at #{Time.new.inspect}</td>
  </tr>
  </table>
  </body>
  </html>
EOF
  end
end

def emailTestResults()
  require 'net/smtp'
  eval File.read("smtp_tls.rb")
  Net::SMTP.enable_tls() 
  #FROM_EMAIL = "REMOVED"
  #PASSWORD = "REMOVED"
  #TO_EMAIL = "REMOVED" 
  message = <<MESSAGE_END
  Yayy Tests all passed Go QA Team!!!
MESSAGE_END
  Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', 'grqateam@gmail.com', 'wergrllc', :plain) do |smtp|
    smtp.send_message message, 'caoxu2000@gmail.com',
                                ['xucaotest1@gmail.com','xucaotest2@gmail.com']
  end
end