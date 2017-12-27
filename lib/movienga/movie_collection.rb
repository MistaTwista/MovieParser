require 'csv'
require_relative 'movies/movie'

module Movienga
  # Presenting movie collection. You can load collection from CSV file,
  # {#filter} and {#sort_by} collection.
  # @attr_reader [Array] movies Return movies in collection
  class MovieCollection
    include Enumerable

    attr_reader :movies

    MOVIE_FIELDS = %i[url title year country date
                      genre length rate director actors].freeze

    # @param filename [String] CSV file to parse movies
    # @param movie_class [Movie] Class for each parsed element
    def initialize(filename, movie_class: Movie)
      @movies = parse_from_file(filename)
                .map { |movie| movie_class.new(movie, self) }
    end

    # Shows all movies in current collection
    def all
      movies
    end

    # Sort collection movies by field
    #
    # @param field [Symbol] Movie field name
    # @return [Array] Sorted movies
    # @example sort by title
    #   collection.sort_by(:title)
    def sort_by(field)
      all.reject { |movie| movie.public_send(field).nil? }
         .compact.sort_by(&field)
    end

    # Filter by collection using movies attributes
    #
    # If no block given use native movies attributes
    # @param attributes [Hash] Movie attributes to filter
    # @param block [Proc] Proc to use with each movie in collection
    # @example filter comedies with Brad Pitt
    #   collection.filter(genre: 'Comedy', actors: 'Brad Pitt')
    # @example filter movies with year > 2003
    #   collection.filter { |m| m.year > 2003 }
    def filter(attributes = {}, &block)
      return all.select(&block) if block_given?

      all.select do |movie|
        movie.matches_all? attributes
      end
    end

    # Shows statistics by fields
    #
    # @param field [Symbol] Collection movies field symbol
    # @return [Hash] Hash with 'field: counter'
    # @example show collection by year
    #   collection.stats(:year) => { 1995: 10, 2005: 5, ... }
    def stats(field)
      all.map(&field).compact.flatten.group_by(&:itself)
         .map { |grouped_by, data| [grouped_by, data.count] }.sort.to_h
    end

    # Shows is there any movie in some genre
    #
    # @param genre [String] genre to search in collection
    # @return [Boolean] true or false
    def has_genre?(genre)
      genres.include?(genre)
    end

    # Enumerable implementation
    def each(&block)
      return movies.each unless block_given?
      movies.each(&block)
    end

    # All genres in collection
    def genres
      @genres ||= all.map(&:genre).flatten.uniq
    end

    private

    def parse_from_file(filename)
      CSV.foreach(filename, col_sep: '|', headers: MOVIE_FIELDS).map(&:to_h)
    end
  end
end
