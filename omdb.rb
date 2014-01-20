require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'
require 'pg'

get '/' do
  
  # create_movies_table()
  erb :index
  
end

def get_typheous_parse (type, name)
 JSON.parse((Typhoeus.get("www.omdbapi.com", :params => {type => name})).body)
end

# def create_movies_table
#   c = PGconn.new(:host => "localhost", :dbname => "testdb")
#   c.exec %q(
#     CREATE TABLE IF NOT EXISTS movies_history (
#       id SERIAL PRIMARY KEY,
#       title TEXT,
#       director TEXT,
#       imdb TEXT,
#       poster TEXT,
#       );
#   )
#   c.close
# end


# the CREATE METHOD
post '/results' do 
  @search_str = params[:movie]

  # get movies from omdb api and parse
  response = get_typheous_parse(:s, @search_str)
  
  # sort the results
  @sorted_result = response["Search"].sort_by{ |movie| movie['Year'] } 

  # loop through each movie, make a new search, grab the rest of the info: director, plot, poster
  @sorted_result.map! do |get|
    get_typheous_parse(:i, get['imdbID'])
  end

  erb :results

end

get '/imdbid/:imdb' do |imdb_id|

  # movie_result = get_typheous_parse(:i, imdb_id)


  # c = PGconn.new(:host => "localhost", :dbname => "testdb")
  # c.exec_params %Q(
  #   INSERT INTO movies_history (title, director, imdb, poster)
  #   VALUES ($1, $2, $3, $4);
  #   ), [movie_result['Title'], movie_result['Director'], imdb_id, movie_result['Poster']] 
  # c.close

  # reroute to imdb's website
  redirect "http://www.imdb.com/title/#{imdb_id}"

end

post '/history' do

  # c = PGconn.new(:host => "localhost", :dbname => "testdb")
  # c.exec %q(
  #   SELECT m.name, m.poster FROM movies_history AS m;
  # )
  # c.close

  erb :history

  #have to work on erb :history

end


get '/results/:year' do 
  @search_str = params[:movie]

  response = get_typheous_parse(:y, @search_str)
  @sorted_result = response["Search"].sort_by{ |movie| movie['Year'] } 
   @sorted_result.map! do |get|
    response2 = get_typheous_parse(:i, get['imdbID'])
  end

end
