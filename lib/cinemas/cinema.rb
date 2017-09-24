require_relative '../movie_builder'
require_relative '../movie_collection'
require_relative '../movienga/cashbox'
require_relative '../errors'

class Cinema < MovieCollection
  attr_reader :movie

  def initialize(filename)
    @movies = parse_from_file(filename).map{ |movie| build_movie(movie) }
  end

  def show
    raise NothingToShow unless movies.any?
    movie = peek_random(movies)
    puts show_movie(movie)
  end

  private

  def peek_random(collection)
    collection.sort_by { |movie| movie.rate * rand }.last
  end

  def show_movie(movie)
    "Now showing: #{movie.to_s} #{movie.from_to}"
  end

  def build_movie(movie_hash)
    MovieBuilder.build_movie(movie_hash, self)
  end
end
