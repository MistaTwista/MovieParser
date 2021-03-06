require 'csv'
require_relative 'movies/movie'

module Movienga
  class MovieCollection
    include Enumerable

    attr_reader :movies

    MOVIE_FIELDS = %i[url title year country date
                      genre length rate director actors].freeze

    def initialize(filename, movie_class: Movie)
      @movies = parse_from_file(filename)
                .map { |movie| movie_class.new(movie, self) }
    end

    def all
      movies
    end

    def sort_by(field)
      all.reject { |movie| movie.public_send(field).nil? }
         .compact.sort_by(&field)
    end

    def filter(params = {}, &block)
      return all.select(&block) if block_given?

      all.select do |movie|
        movie.matches_all? params
      end
    end

    def stats(field)
      all.map(&field).compact.flatten.group_by(&:itself)
         .map { |grouped_by, data| [grouped_by, data.count] }.sort.to_h
    end

    def has_genre?(genre)
      genres.include?(genre)
    end

    def each(&block)
      return movies.each unless block_given?
      movies.each(&block)
    end

    def genres
      @genres ||= all.map(&:genre).flatten.uniq
    end

    private

    def parse_from_file(filename)
      CSV.foreach(filename, col_sep: '|', headers: MOVIE_FIELDS).map(&:to_h)
    end
  end
end
