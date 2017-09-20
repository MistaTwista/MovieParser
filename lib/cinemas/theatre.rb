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
    movies.map { |m| { m.title => when_to_show_movie(m) } } if movies.any?
  end

  private

  def filter_by_time(time)
    time = DateTime.parse(time).hour
    _, period = TIME_TABLE.select{ |range| range.include? time }.first
    raise "Theatre is closed in #{time}" if period.nil?
    filter(PERIODS[period])
  end

  def when_to_show_movie(movie)
    result = TIME_TABLE.map { |_, period|
      period if movie.matches_all?(PERIODS[period])
    }.compact

    result << :never if result.empty?
    result.uniq
  end
end
