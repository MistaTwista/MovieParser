require_relative 'movie'

module Movienga
  class ClassicMovie < Movie
    def to_s
      format(
        '%s - classic movie, director: %s, also: %s',
        title,
        director,
        other_directors_movies
      )
    end

    private

    def other_directors_movies
      @collection.filter(director: director).map(&:title).take(10).join(', ')
    end
  end
end
