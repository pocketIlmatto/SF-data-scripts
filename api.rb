require 'soda'
require 'pry'
require 'httparty'
require 'uri'

# client_id = "d6WQMxNPWIFQOuAJYywMwAhO7"
# client_secret = "dqBjdSzynApX_6Rg6oQ9D-BSIMRZzGLn3Ryg"
#foursquare
CLIENT_ID = 'IB0RW315X2EQ5TIHWSZ1LCUBGNJB4ZHULCOLLQGFWYOWGV0Q'
CLIENT_SECRET = 'FRCDCTULYEIMNEINZZJTITE0X1ZLEC5IPXZYR5XJ4Q20UZLQ'
client = SODA::Client.new({domain: "data.sfgov.org", app_token: "ZLbWZk9TLVX5wH72xaGBs0NGm", ignore_ssl: true})

def check_foursquare(lat, lon, name)
  food_truck = {}
  api_r = HTTParty.get("https://api.foursquare.com/v2/venues/search?"\
                       "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20130815&ll=#{lat},#{lon}"\
  "&query=#{URI::encode(name)}")

  food_truck['name'] = name
  food_truck['checkins'] = api_r["response"]["venues"][0]["stats"]["checkinsCount"].to_i if api_r["response"]["venues"][0]
  food_truck['checkins'] ||= 0
  food_truck
end



# table = "gxxq-x39z" #Crime
# table = "vt9c-aeiw" #Businesses
# table = "qwyj-4qec" #restaurants
table = "rqzj-sfat" #mobile food permits

#response = client.get(table, {"$limit" => 20, "Zip_Code" => "94115"})
#response = client.get(table, {"$limit" => 20, "DayOfWeekStr" => "Friday"})
response = client.get(table, {"$limit" => 20})

food_trucks = []
response.each do |result|
  lon   = result['location']['longitude']
  lat     = result['location']['latitude']
  name   = result['applicant']
  if name
    food_trucks << check_foursquare(lat, lon, name)
  end


end

food_trucks.sort! {|a, b| b['checkins'] <=> a['checkins']}

food_trucks.each do |v|
  puts "Food truck #{v['name']}, checkins #{v['checkins']}"
end





