require 'date'
require 'virtus'

class MovieLength < Virtus::Attribute
  def coerce(value)
    value.to_i
  end
end

class StringArray < Virtus::Attribute
  def coerce(value)
    value.split(',')
  end
end

module Movienga
  class Movie
    attr_reader :to_h
    include Virtus.model

    attribute :length, MovieLength
    attribute :rate, Float
    attribute :genre, StringArray
    attribute :actors, StringArray

    def initialize(movie, collection = nil)
      @to_h = movie
      self.attributes = movie
      @collection = collection
    end

    def has_genre?(genre)
      raise "No #{genre} in a collection :(" unless collection_has_genre? genre
      self.genre.include?(genre)
    end

    def month
      return nil unless /^\d{4}-\d{2}/.match?(to_h[:date])
      month_from_date = Date.strptime(to_h[:date], '%Y-%m').mon
      Date::MONTHNAMES[month_from_date]
    end

    def year
      Date.strptime(to_h[:year], '%Y').year
    end

    def date
      return nil unless /^\d{4}-\d{2}-\d{2}/.match?(to_h[:date])
      Date.strptime(to_h[:date])
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
        filter_value === value # rubocop:disable Style/CaseEquality
      end
    end

    def to_s
      format(
        '%s (%s) %i; %s; %i min',
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
      period&.downcase&.to_sym
    end

    def format_time(time)
      time.strftime('%H:%M')
    end

    def collection_has_genre?(genre)
      return false if @collection.nil?
      @collection.has_genre?(genre)
    end

    def method_missing(name, *args)
      return to_h[name] if to_h.key?(name)
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      to_h.key?(method_name) || super
    end
  end
end
