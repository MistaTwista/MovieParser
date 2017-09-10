require_relative '../movie'

class NewMovie < Movie
  def to_s
    "#{title} - new movie! #{years_ago}"
  end

  private

  def years_ago
    return "#{this_year - year} years ago" if this_year > year
    ""
  end

  def this_year
    Time.now.year
  end
end
