require_relative 'movie'

module Movienga
  class ModernMovie < Movie
    def to_s
      "#{title} - modern movie. Actors: #{actors.join(', ')}"
    end
  end
end
