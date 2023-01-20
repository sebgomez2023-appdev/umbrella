require("open-uri")
require("json")

line_width = 35

p "="*line_width
p "Will you need an umbrella today?".center(line_width)
p "="*line_width
p "Where are you located?"

user_location = gets.chomp

gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{ user_location }&key=#{gmaps_key}"


raw_data = URI.open(gmaps_url).read


JSON.parse(raw_data)

parsed_data = JSON.parse(raw_data)

parsed_data.keys

results_array = parsed_data.fetch("results")

only_result = results_array[0]

geometry = only_result.fetch("geometry")

location = geometry.fetch("location")

latitude = location.fetch("lat")

longitude = location.fetch("lng")

p "Your coordinates are #{latitude}, #{longitude}"

latitude 
p longitude

dark_sky_key = ENV.fetch("DARK_SKY_KEY")
dark_sky_url = "https://api.darksky.net/forecast/#{dark_sky_key}/#{latitude},#{longitude}"

raw_dark_sky_data = URI.open(dark_sky_url).read

JSON.parse(raw_dark_sky_data)

parsed_dark_sky_data = JSON.parse(raw_dark_sky_data)

currently_hash = parsed_dark_sky_data.fetch("currently")

temperature_hash = currently_hash.fetch("temperature")

p "Its currently #{temperature_hash} °F."


hourly_hash = parsed_dark_sky_data.fetch("hourly")

hourly_data_array = hourly_hash.fetch("data")

next_twelve_hours = hourly_data_array[1..12]

precip_prob_threshold = 0.20

any_precipitation = false

next_twelve_hours.each do |hour_hash|

  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
