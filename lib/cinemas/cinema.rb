require_relative '../movie_builder'
require_relative '../movie_collection'
require_relative '../errors'

class Cinema < MovieCollection
  attr_reader :movie

  def initialize(filename)
    @movies = parse_from_file(filename).map{ |movie| build_movie(movie) }
  end

  def show
    @movie = select_from_collection(movies)
    raise NothingToShow unless movie
    puts show_movie
  end

  private

  def select_from_collection(collection)
    collection.sample
  end

  def show_movie
    "Now showing: #{movie.to_s} #{movie.from_to}"
  end

  def build_movie(movie_hash)
    MovieBuilder.build_movie(movie_hash, self)
  end
end
