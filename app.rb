require 'irb'

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/csv_to_hash'
require_relative 'lib/movie_collection'

MOVIE_FIELDS = %i[url title year country date
  genre length rate director actors].freeze

collection = CsvToHash.new(filename, MOVIE_FIELDS).data
movies = MovieCollection.new(collection)
p movies.all.first
# p movies.sort_by(:date).first 5
p movies.filter(genre: 'Crime')
