require_relative 'cinema'

class Theatre < Cinema
  DAY_GENRES = ['Comedy', 'Adventure']
  EVENING_GENRES = ['Drama', 'Horror']

  def show(time)
    movies = select_by_daytime time_to_daytime(time)
    @movie = select_from_collection(movies)
    puts show_movie
  end

  def when?(title)
    movies = filter(title: title)
    when_to_show_movie(movies.first) if movies.any?
  end

  private

  def time_to_daytime(time)
    case time.hour
    when 0..6 then :evening
    when 7..12 then :morning
    when 13..17 then :day
    when 17..23 then :evening
    end
  end

  def select_by_daytime(daytime)
    result = []
    result << filter(period: :ancient) if daytime == :morning
    result << filter(genre: DAY_GENRES) if daytime == :day
    result << filter(genre: EVENING_GENRES) if daytime == :evening
    result.flatten.uniq
  end

  def when_to_show_movie(movie)
    result = []
    result << :morning if movie.period == :ancient
    result << :day if (movie.genre & DAY_GENRES).any?
    result << :evening if (movie.genre & EVENING_GENRES).any?
    raise 'We cant show this movie' if result.empty?
    result
  end
end
