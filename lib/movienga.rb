require_relative 'movienga/version'
require_relative 'movienga/tmdb_parser'
require_relative 'movienga/imdb_parser'
require_relative 'movienga/movie_collection'
require_relative 'movienga/collection_enumerator'
require_relative 'movienga/cache'
require_relative 'movienga/cinemas/netflix'
require_relative 'movienga/cinemas/theatre'

# Movienga is a simple movie collection database.
#
# You can try it with:
#   netflix = Movienga::Netflix.new('spec/data/movies.txt', 10)
#   # and find movie
#   netflix.show
#
# or just start simple webserver for demo collection with:
#
#   $ rackup
#
# There is some classes you can use for your needs:
#
# * {Movie} -- abstract movie class with basic functionality,
#   there is also {AncientMovie}, {ClassicMovie},
#   {ModernMovie} and {NewMovie} with little differences;
# * {Cinema} -- abstract Cinema class with basic functionality,
#   and also {Netflix} with {Netflix#filter} and {Theatre} with timetable
#   scheduler;
# * {Cashbox} -- module with cashbox functionality. Allows you to add cash
#   to classes like Theatre ticket service.
# * {Cache} -- class for persist data in yaml files. There is also {FileCache}
#   that allows us to download file by url and save it to disk;
#
# You also may be interested in (though may be never need to use them directly):
#
# * {IMDBParser} Takes movie budget from IMDB page
# * {TMDBParser} Get movie data and put it to data.yml with poster.jpg
module Movienga
end
