require_relative 'cinema'

class Theatre < Cinema
  PERIODS = {
    morning: { period: :ancient },
    day: { genre: ['Comedy', 'Adventure'] },
    evening: { genre: ['Drama', 'Horror'] }
  }

  TIME_TABLE = {
    9...13 => :morning,
    13...17 => :day,
    17..23 => :evening
  }

  def show(time = Time.now.strftime("%H:%M"))
    movies = filter_by_time(time)
    raise NothingToShow, time unless movies.any?
    movie = peek_random(movies)
    puts show_movie(movie)
  end

  def when?(title)
    movies = filter(title: title)
    movies.reduce({}) do |acc, m|
      acc[m.title] = when_to_show_movie(m)
      acc
    end
  end

  private

  def filter_by_time(time)
    time = DateTime.parse(time).hour
    _, period = TIME_TABLE.select{ |range| range.include? time }.first
    raise "Theatre is closed in #{time}" if period.nil?
    filter(PERIODS[period])
  end

  def when_to_show_movie(movie)
    TIME_TABLE
      .select { |_, period| movie.matches_all?(PERIODS[period]) }
      .map(&:last)
      .uniq
  end
end
