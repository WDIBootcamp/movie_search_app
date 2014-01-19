require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  
  erb :index
  #display movies
end

def get_typheous_parse (type, name)
 JSON.parse((Typhoeus.get("www.omdbapi.com", :params => {type => name})).body)
end


# the CREATE METHOD
post '/results' do
  @search_str = params[:movie]

  # get movies from omdb api and parse
  response = get_typheous_parse(:s, @search_str)
  
  # sort the results
  @sorted_result = response["Search"].sort_by{ |movie| movie['Year'] } 

  # loop through each movie, make a new search, grab the rest of the info: director, plot, poster
  @sorted_result.map! do |get|
    response2 = get_typheous_parse(:i, get['imdbID'])
    get = response2
  end

  erb :results

end


get '/imdbid/:imdb' do |imdb_id|

  # reroute to imdb's website
  redirect "http://www.imdb.com/title/#{imdb_id}"

end

