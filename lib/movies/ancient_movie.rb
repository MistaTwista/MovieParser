require_relative '../movie'

class AncientMovie < Movie
  def to_s
    "#{title} - ancient movie (#{year})"
  end
end
