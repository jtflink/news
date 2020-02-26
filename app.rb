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
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates
    forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash

    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=09b48d36f80a4001a2efbef6d66b32f3"
    news = HTTParty.get(url).parsed_response.to_hash
    
    @current_temp = forecast["currently"]["temperature"]
    @current_conditions = forecast["currently"]["summary"]
    @location = params["location"]
    @extended_forecast = forecast["daily"]["data"]

    @articles = news["articles"]

    view "news"
end