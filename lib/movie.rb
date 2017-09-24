require 'date'

module Movienga
  class Movie
    attr_reader :to_h

    def initialize(movie, collection = nil)
      @to_h = movie
      @collection = collection
    end

    def has_genre?(genre)
      raise "No #{genre} in a collection :(" unless collection_has_genre? genre
      self.genre.include?(genre)
    end

    def month
      Date::MONTHNAMES[Date.strptime(to_h[:date], "%Y-%m").mon] rescue nil
    end

    def year
      Date.strptime(to_h[:year], "%Y").year
    end

    def length
      to_h[:length].to_i
    end

    def rate
      to_h[:rate].to_f
    end

    def genre
      to_h[:genre].split(',')
    end

    def actors
      to_h[:actors].split(',')
    end

    def date
      Date.strptime(to_h[:date]) rescue nil
    end

    def period
      self.class.period
    end

    def from_to(movie_start = Time.now)
      movie_end = movie_start + length * 60
      "#{format_time(movie_start)} - #{format_time(movie_end)}"
    end

    def matches_all?(filters)
      filters.all? { |name, value| matches?(name, value) }
    end

    def matches?(field, filter_value)
      value = public_send(field)
      return false if value.nil?

      case filter_value
      when Array
        (value & filter_value).any?
      when String
        value.include? filter_value
      else
        filter_value === value
      end
    end

    def to_s
      format('%s (%s) %i; %s; %i min',
        title,
        actors.join(', '),
        year,
        genre.join(', '),
        length
      )
    end

    def inspect
      "#<#{self.class.name} #{title} #{genre} #{date}>"
    end

    private

    def self.period
      period = name.scan(/(\w+)Movie/).flatten.first
      period.downcase.to_sym unless period.nil?
    end

    def format_time(time)
      time.strftime("%H:%M")
    end

    def collection_has_genre?(genre)
      return true if @collection.nil?
      @collection.has_genre?(genre)
    end

    def method_missing(name, *args)
      name = name.to_sym
      return to_h[name] if to_h.key?(name)
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      to_h.key?(method_name) || super
    end
  end
end
