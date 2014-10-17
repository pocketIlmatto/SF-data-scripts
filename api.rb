require 'soda'
require 'pry'
require 'httparty'
require 'uri'

#foursquare
client_id = 'IB0RW315X2EQ5TIHWSZ1LCUBGNJB4ZHULCOLLQGFWYOWGV0Q'
client_secret = 'FRCDCTULYEIMNEINZZJTITE0X1ZLEC5IPXZYR5XJ4Q20UZLQ'

client = SODA::Client.new({:domain => "data.sfgov.org",:app_token => "ZLbWZk9TLVX5wH72xaGBs0NGm"})

table = "gxxq-x39z" #Crime
table = "vt9c-aeiw" #Businesses
table = "qwyj-4qec" #restaurants
table = "rqzj-sfat" #mobile food permits

#response = client.get(table, {"$limit" => 20, "Zip_Code" => "94115"})
response = client.get(table, {"$limit" => 20, "DayOfWeekStr" => "Friday"})

response.each do |result|
	lon 	= result['location']['longitude']
	la 		= result['location']['latitude']
	name 	= result['Applicant']

	api_r = HTTParty.get("https://api.foursquare.com/v2/venues/search?"\
		"client_id=#{client_id}&client_secret=#{client_secret}&v=20130815&ll=#{la},#{lon}"\
		"&query=#{URI::encode(name)}")
  
	result['checkins'] = api_r["response"]["venues"][0]["stats"]["checkinsCount"] unless api_r["response"]["venues"][0]["stats"]["checkinsCount"].nil?
	result['checkins'] = result['checkins'].nil? ? 0 : result['checkins'].to_i
	
end

response.sort! {|a, b| b['checkins'] <=> a['checkins']}

response.each do |v| 
	puts "Food truck #{v['Applicant']}, checkins #{v['checkins']}"
end





