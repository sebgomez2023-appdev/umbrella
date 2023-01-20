p "Where are you located?"

user_location = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{ user_location }&key=AIzaSyB92cYxPcYqgjwBJfWlwDQw_7yjuyU3tpA"

require("open-uri")

raw_data = URI.open(gmaps_url).read

require("json")
 
JSON.parse(raw_data)

parsed_data = JSON.parse(raw_data)

parsed_data.keys

results_array = parsed_data.fetch("results")

only_result = results_array[0]

geometry = only_result.fetch("geometry")

location = geometry.fetch("location")

latitude = location.fetch("lat")

longitude = location.fetch("lng")

p latitude 
p longitiude

dark_sky_key = "https://api.darksky.net/forecast/71174c5d293588d2f0ba4c0c7448bcfb/#{latitude},#{longitude}"
