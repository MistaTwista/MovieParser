require_relative '../movie'

module Movienga
  class AncientMovie < Movie
    def to_s
      "#{title} - ancient movie (#{year})"
    end
  end
end
