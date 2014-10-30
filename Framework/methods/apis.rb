require 'helpers/readExcel.rb'
require 'rest_client'
# require 'ap'

def call_apis()    
    begin
      if ($apiMethod.include? "post")
        $apiResponse = RestClient.post $apiPath, $apiRequest, {:content_type => 'application/json' }
      elsif ($apiMethod.include? "put")
        $apiResponse = RestClient.put $apiPath, $apiRequest, {:content_type => 'application/json' }
      elsif ($apiMethod.include? "get")
        $apiResponse = RestClient.get $apiPath, {:content_type => 'application/json', :Authorization => 'Basic NmVkODJhMTMtOTA1ZC00Y2NkLWE3NjktY2IzNzlhZWQ3OWEwOmEwNDFmOGRjLWM4NmMtNGUzZi1kOTA3LTM2Y2Q5OGZjMDkyNA==' }
      else
        puts "Method is not coded yet: Not GET, POST or PUT"
      end         
      puts "#{$apiName},  passed :#{$apiResponse.code}"
      File.open( "/Users/sonyit/Desktop/qa/Framework/output/mcs_api/passed/#{$apiName}.txt", "w" ) do |the_file|
      the_file.puts $apiResponse
      end
      # File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony/MCS_Automation_Framework/output/mcs_api/passed/#{Time.now}.txt", "a+" ) do |the_file|
      # the_file.puts $apiName
      # end  
    rescue => e
      puts "#{$apiName},  failed" 
      #ap e   
      puts e                       
       File.open( "/Users/sonyit/Desktop/qa/Framework/output/mcs_api/failed/#{$apiName}.txt", "w" ) do |the_file|
       the_file.puts $apiResponse
       end
       # File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony/MCS_Automation_Framework/output/mcs_api/failed/#{Time.now}.txt", "a+" ) do |the_file|
       # the_file.puts $apiName
       # end  
    end
end
