require_relative 'movie'

class MovieCollection
  attr_reader :movies

  def initialize(collection, movie_class: Movie)
    @movies = collection.map{ |movie| movie_class.new(movie) }
  end

  def all
    movies
  end

  def sort_by(field)
    begin
      all.sort_by(&field)
    rescue Exception => e
      puts "Collection can't be sorted by #{field}, some data is not valid"
    end
  end

  def filter(*fields)
    all.select{ |movie| fields.map{ |k, v| movie.send(k).include?(v) } }
  end

  def testable
    42
  end
end
