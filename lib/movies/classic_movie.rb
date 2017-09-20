require_relative '../movie'

class ClassicMovie < Movie
  def to_s
    "#{title} - classic movie, director: #{director}, also: #{other_directors_movies}"
  end

  private

  def other_directors_movies
    @collection.filter(director: director).map(&:title).take(10).join(', ')
  end
end
