require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  
  erb :index
  #display movies
end

# the CREATE METHOD
post '/results' do
  # the movie selected
  @search_str = params[:movie]

  # get movies from omdb api
  response = Typhoeus.get("www.omdbapi.com", :params => {:s => @search_str})
  # parsing(making it look nice) -- the hash
  result = JSON.parse(response.body)
  # sorting the results
  @sorted_result = result["Search"].sort_by{ |movie| movie['Year'] } 

  # loop through each movie, make a new search, grab the rest of the info: director, plot, poster

  erb :results

end

# the SHOW METHOD/ROUTE for movie
get '/movies/:imdb' do |imdb_id|

  response2 = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id})
  @result2 = JSON.parse(response2.body)

  erb :movie
  
end


get '/imdbid/:imdb' do |imdb_id|

  # reroute to imdb's website
  redirect "http://www.imdb.com/title/#{imdb_id}"

end

