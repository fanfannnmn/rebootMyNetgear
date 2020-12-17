# frozen_string_literal: true

require 'mechanize'
require 'net/http'
require 'uri'

# -----------------------------------------------
# customize user credentials
# -----------------------------------------------
router_ip = '10.0.0.1'
username = 'admin'
password = ''

# -----------------------------------------------
# get cookie, and unique query for POST request
# -----------------------------------------------
agent = Mechanize.new
# authenticate scrapper
agent.add_auth "http://#{router_ip}", username, password

# retrieve page and search unique query (id)
page = agent.get "http://#{router_ip}/ADVANCED_home2.htm"
query = page.search('//body/form')[0]['action']

# save cookies
cookie = agent.cookies[0]

# -----------------------------------------------
# construct the POST request
# -----------------------------------------------
uri = URI "http://#{router_ip}/#{query}"
http = Net::HTTP.new uri.host, uri.port
http.use_ssl = false
request = Net::HTTP::Post.new query
request.basic_auth username, password
request['Content-Type'] = 'application/x-www-form-urlencoded'
request['Cookie'] = cookie
request['Connection'] = 'close'
request.body = 'buttonSelect=2&wantype=static&enable_apmode=0'

# output response
response = http.request request
if response.code.eql? '200'
  puts '200: Success'
else
  puts "HTTP Response Code: #{response.code}"
end
