require 'csv'
require_relative 'movie'

class MovieCollection
  attr_reader :movies

  MOVIE_FIELDS = %i[url title year country date
    genre length rate director actors].freeze

  def initialize(filename, movie_class: Movie)
    @movies = parse_from_file(filename)
      .map{ |movie| movie_class.new(movie) }
  end

  def all
    movies
  end

  def sort_by(field)
    all.reject { |movie| movie.public_send(field).nil? }
      .compact.sort_by(&field)
  end

  def filter(options)
    all.select do |movie|
      options.to_a.all? do |o, matcher|
        matches?(movie.public_send(o), matcher)
      end
    end
  end

  def stats(field)
    all
      .map{ |m| m.public_send(field) }
      .compact.flatten
      .group_by(&:itself)
      .map{ |grouped_by, data| [grouped_by, data.count] }.to_h
  end

  private

  def matches?(value, matcher)
    case matcher
    when Regexp
      value.to_s.match? matcher
    when Range
      matcher.include? value
    else
      value.to_s.include? matcher.to_s
    end
  end

  def parse_from_file(filename)
    CSV.foreach(filename, { col_sep: '|', headers: MOVIE_FIELDS }).map(&:to_h)
  end
end
