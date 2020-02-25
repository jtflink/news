require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

ForecastIO.api_key = "103c9e3d94ccd1d6356896c2d9c4db5f"

get "/" do
  view "ask"
end

get "/news" do
  results = Geocoder.search(params["q"])
  lat_long = results.first.coordinates
  forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash
  @weather = "#{forecast["daily"]["data"][0]["temperatureHigh"]}"

  view "news"
end