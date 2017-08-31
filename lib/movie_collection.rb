require 'csv'
require_relative 'movie'

class MovieCollection
  attr_reader :movies

  MOVIE_FIELDS = %i[url title year country date
    genre length rate director actors].freeze

  def initialize(filename, movie_class: Movie)
    @movies = parse_from_file(filename)
      .map{ |movie| movie_class.new(movie, self) }
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
      options.all? do |option, matcher|
        matches?(movie.public_send(option), matcher)
      end
    end
  end

  def stats(field)
    all.map(&field).compact.flatten.group_by(&:itself)
      .map{ |grouped_by, data| [grouped_by, data.count] }.sort.to_h
  end

  def has_genre?(genre)
    @collection_genres ||= all.map(&:genre).flatten.uniq
    @collection_genres.include?(genre)
  end

  private

  def matches?(value, matcher)
    return false if value.nil?
    case matcher
    when Array, String
      value.include? matcher
    else
      matcher === value
    end
  end

  def parse_from_file(filename)
    CSV.foreach(filename, { col_sep: '|', headers: MOVIE_FIELDS }).map(&:to_h)
  end
end
