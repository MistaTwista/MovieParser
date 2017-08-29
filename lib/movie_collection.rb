require_relative 'movie'
require_relative 'csv_to_hash'

class MovieCollection
  attr_reader :movies

  MOVIE_FIELDS = %i[url title year country date
    genre length rate director actors].freeze

  def initialize(filename, movie_class: Movie)
    @movies = CsvToHash.new(filename, MOVIE_FIELDS).data
      .map{ |movie| movie_class.new(movie) }
  end

  def all
    movies
  end

  def sort_by(field)
    all.map do |movie|
      field_data = movie.public_send(field) rescue nil
      field_data.nil? ? nil : movie
    end.compact.sort_by(&field)
  end

  def filter(field)
    key, value = field.first
    all.select{ |movie| movie.public_send(key).to_s.include?(value.to_s) }
  end

  def stats(field)
    all
      .map{ |m| m.public_send(field) rescue nil }
      .compact.flatten
      .group_by(&:itself)
      .map{ |grouped_by, data| [grouped_by, data.count] }.to_h
  end
end
