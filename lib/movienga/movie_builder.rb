require_relative 'movies/ancient_movie'
require_relative 'movies/classic_movie'
require_relative 'movies/modern_movie'
require_relative 'movies/new_movie'

module Movienga
  class MovieBuilder
    def self.build_movie(movie, collection = nil)
      movie_class = case movie[:year].to_i
                    when 1900..1945
                      AncientMovie
                    when 1945..1968
                      ClassicMovie
                    when 1968..2000
                      ModernMovie
                    when 2000..Time.now.year
                      NewMovie
                    else
                      raise 'Movie year is out of range'
                    end

      movie_class.new(movie, collection)
    end
  end
end
