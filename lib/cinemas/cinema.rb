require_relative '../movie_builder'
require_relative '../movie_collection'

class Cinema < MovieCollection
  attr_reader :movie

  def initialize(filename)
    @movies = parse_from_file(filename).map{ |movie| build_movie(movie) }
  end

  def show
    @movie = select_from_collection(movies)
    show_movie
  end

  private

  def select_from_collection(collection)
    collection.sample
  end

  def show_movie
    "Now showing: #{movie.to_s}"
  end

  def movie_from_to
    movie_start = Time.now
    movie_end = movie_start + (movie.length * 60)
    "#{format_time(movie_start)} - #{format_time(movie_end)}"
  end

  def format_time(time)
    time.strftime("%H:%m")
  end

  def build_movie(movie_hash)
    MovieBuilder.build_movie(movie_hash, self)
  end
end
