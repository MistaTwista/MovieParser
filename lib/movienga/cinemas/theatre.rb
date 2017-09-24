require_relative 'cinema'
require_relative '../cashbox'

module Movienga
  class Theatre < Cinema
    include Cashbox

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

    PRICE_LIST = {
      morning: 3,
      day: 5,
      evening: 10
    }

    def show(time = Time.now.strftime("%H:%M"))
      movies = filter_by_time(time)
      raise NothingToShow, time unless movies.any?
      movie = peek_random(movies)
      puts show_movie(movie)
    end

    def when?(title)
      filter(title: title).map { |m| [m.title, when_to_show_movie(m)] }.to_h
    end

    def buy_ticket(title)
      period = when?(title)[title].first
      raise NothingToShow unless period
      deposit_cash PRICE_LIST[period]
      puts "You bought ticket to #{title}"
    end

    private

    def filter_by_time(time)
      period = period_from_time(time)
      raise "Theatre is closed in #{time}" if period.nil?
      filter(PERIODS[period])
    end

    def when_to_show_movie(movie)
      TIME_TABLE
        .select { |_, period| movie.matches_all?(PERIODS[period]) }
        .map(&:last)
        .uniq
    end

    def period_from_time(time)
      time = DateTime.parse(time).hour
      _, period = TIME_TABLE.select{ |range| range.include? time }.first
      period
    end
  end
end
