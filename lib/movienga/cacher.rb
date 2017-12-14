require 'dotenv'
Dotenv.load

require 'ruby-progressbar'
require_relative './tmdb_parser'
require_relative './movie_collection'

module Movienga
  class Cacher
    using ProgressBar::Refinements::Enumerator

    def initialize(collection)
      @collection = collection
    end

    def run(title: 'Caching', &block)
      @collection.each.with_progressbar(title: title, &block)
    end
  end
end

parser = Movienga::TMDBParser.new(api_key: ENV['API_KEY'])
collection = Movienga::MovieCollection.new(ENV['DATA_PATH'])

cacher = Movienga::Cacher.new(collection)

cacher.run(title: 'Caching Ru') { |item| parser.parse(item.imdb_id) }

parser.set_language('en')
cacher.run(title: 'Caching En') { |item| parser.parse(item.imdb_id) }
