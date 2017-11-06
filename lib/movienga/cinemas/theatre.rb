require_relative 'cinema'
require_relative '../cashbox'

module Movienga
  class Theatre < Cinema
    include Cashbox

    PERIODS = {
      morning: { period: :ancient },
      day: { genre: %w[Comedy Adventure] },
      evening: { genre: %w[Drama Horror] }
    }.freeze

    TIME_TABLE = {
      9...13 => :morning,
      13...17 => :day,
      17..23 => :evening
    }.freeze

    PRICE_LIST = {
      morning: 3,
      day: 5,
      evening: 10
    }.freeze

    def initialize(filename, &block)
      super(filename)
      instance_eval(&block) if block_given?
    end

    def show(time = Time.now.strftime('%H:%M'), hall_name = nil)
      movies = filter_by_time(time, hall_name)
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

    def get_hall(name)
      hall = halls[name]
      hall.nil? ? raise("No such hall name #{name}") : hall
    end

    private

    def hall(name, **args)
      halls[name] = Hall.new(args)
    end

    def period(time_range, &block)
      periods << [time_range, Period.new(time_range, self, &block)]
    end

    def halls
      @halls ||= {}
    end

    def periods
      @periods ||= []
    end

    def filter_by_time(time, hall_name)
      periods = period_from_time(time, hall_name)
      raise "No movies at #{time}" if periods.empty?
      filter(periods.first.filter)
    end

    def period_from_time(time, hall_name)
      by_time = periods.select { |range, _| range.include?(time) }.map(&:last)
      return [] if by_time.empty?
      raise "Please enter hall name" if by_time.count > 1 && hall_name.nil?
      return by_time if by_time.count == 1
      by_time.select { |period| period.halls.include?(hall_name) }
    end

    def when_to_show_movie(movie)
      TIME_TABLE
        .select { |_, period| movie.matches_all?(PERIODS[period]) }
        .map(&:last)
        .uniq
    end
  end

  class Hall
    attr_reader :title, :places

    def initialize(title:, places:)
      @title = title
      @places = places
    end

    def add_period(period)
      time_range = period.time_range
      unless period_available?(time_range)
        raise "#{time_range} is not available in #{self.title}"
      end

      periods[time_range] = period
    end

    def periods
      @periods ||= {}
    end

    private

    def period_available?(time_range)
      self.periods.select { |period|
        TimePeriod.new(period).intersects?(time_range)
      }.empty?
    end
  end

  class TimePeriod
    attr_reader :period

    def initialize(time_range)
      period_min = DateTime.parse(time_range.min)
      period_max = DateTime.parse(time_range.max)
      if time_range.exclude_end?
        @period = period_min...period_max
      else
        @period = period_min..period_max
      end
    end

    def intersects?(time_range)
      range = TimePeriod.new(time_range)
      period.cover?(range.period.min) || period.cover?(range.period.max)
    end
  end

  class Period
    attr_reader :time_range, :description, :price, :filter, :halls

    def initialize(time_range, cinema, &block)
      @time_range = time_range
      @cinema = cinema
      instance_eval(&block)
    end

    def description(period_description)
      @description = period_description
    end

    def filters(args)
      # @filter = ->(movie) { movie.matches_all?(args) }
      @filter = args
    end

    def price(amount)
      @price = amount
    end

    def hall(*names)
      cinema_halls = names.map { |name| cinema.get_hall(name) }
      cinema_halls.each { |hall| hall.add_period(self) }
      @halls = names
    end

    private

    def cinema
      @cinema
    end
  end
end
