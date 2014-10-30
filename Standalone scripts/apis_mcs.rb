require "rubygems" # install ruby 1.8.7
require 'active_support/secure_random'  # gem install active_support
require 'rest_client' # gem install restClient
require 'roo' # gem install roo
require 'ap'

def readExcel()
  oo = Excelx.new("/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony MCS/Sony MCS Scripts/input/apis.xlsx") # add the location to your excel api file
  oo.default_sheet = oo.sheets.first
  2.upto(30) do |line|
    $apiName      = oo.cell(line,'A')
    $apiMethod    = oo.cell(line,'B')
    $apiPath      = oo.cell(line,'C')
    $apiRequest   = oo.cell(line,'D')
    $apiHeader    = oo.cell(line,'E')
    $apiResponse  = oo.cell(line,'F') 
    restCall()
  end  
end


def restCall()

    begin
      $url = "https://auth-api.dev.agorapic.com/" # MCS Auth APIs
      $uri = $url + $apiPath
      if ($apiMethod.include? "post")
        $apiResponse = RestClient.post $uri, $apiRequest, {:content_type => 'text/xml' }
      elsif ($apiMethod.include? "put")
        $apiResponse = RestClient.put $uri, $apiRequest, {:content_type => 'text/xml' }
      elsif ($apiMethod.include? "get")
        $apiResponse = RestClient.get $uri  
      else
        puts "Method is not coded yet: Not GET, POST or PUT"
      end         
      puts "#{$apiName},  passed :#{$apiResponse.code}"
      File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony MCS/Sony MCS Scripts/output/mcs_api/passed/#{$apiName}.txt", "w" ) do |the_file|
      the_file.puts $apiResponse
      end
      File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony MCS/Sony MCS Scripts/output/mcs_api/passed/#{Time.now}.txt", "a+" ) do |the_file|
      the_file.puts $apiName
      end  
    rescue => e
      puts "#{$apiName},  failed" 
      ap e   
      puts e              
      File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony MCS/Sony MCS Scripts/output/mcs_api/failed/#{Time.now}.txt", "a+" ) do |the_file|
      the_file.puts $apiName
      end           
      File.open( "/Users/sonyit/Documents/Aptana Studio 3 Workspace/Sony MCS/Sony MCS Scripts/output/mcs_api/failed/#{$apiName}.txt", "w" ) do |the_file|
      the_file.puts $apiName
      end
    end
  end  
readExcel()