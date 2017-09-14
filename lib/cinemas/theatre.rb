require_relative 'cinema'

class Theatre < Cinema
  MORNING = { time: :morning, filter: [:period, :ancient] }
  DAY = { time: :day, filter: [:genre, ['Comedy', 'Adventure']] }
  EVENING = { time: :evening, filter: [:genre, ['Drama', 'Horror']] }

  TIME_TABLE = {
    7..12 => MORNING,
    13..17 => DAY,
    17..23 => EVENING,
    0..6 => EVENING
  }

  def show(time = nil)
    movies = select_by_time(time)
    @movie = select_from_collection(movies)
    puts show_movie
  end

  def when?(title)
    movies = filter(title: title)
    movies.map { |m| { m.title => when_to_show_movie(m) } } if movies.any?
  end

  private

  def select_by_time(time = nil)
    return movies if time.nil?
    time = DateTime.parse(time).hour
    result = []

    TIME_TABLE.each do |time_range, params|
      param, value = params[:filter]
      result << filter(param => value) if time_range.include? time
    end

    result.flatten.uniq
  end

  def when_to_show_movie(movie)
    result = []

    TIME_TABLE.each do |time_range, params|
      result << params[:time] if movie.match?(params[:filter])
    end

    result << :never if result.empty?
    result.uniq
  end
end
