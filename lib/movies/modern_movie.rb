require_relative '../movie'

class ModernMovie < Movie
  def to_s
    "#{title} - modern movie. Actors: #{actors.join(', ')}"
  end
end
