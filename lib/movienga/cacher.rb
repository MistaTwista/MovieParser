require 'dotenv'
Dotenv.load

require 'ruby-progressbar'
require_relative './tmdb_parser'
require_relative './imdb_parser'
require_relative './movie_collection'

module Movienga
  class Cacher
    using ProgressBar::Refinements::Enumerator

    def initialize(collection)
      @collection = collection
    end

    def run(title: 'Caching', &block)
      @collection.each.with_progressbar(
        title: title,
        format: "%t: Processed %c/%C |%b>%i| %p%% %e %a",
        &block
      )
    end
  end
end

tmdb_parser = Movienga::TMDBParser.new(api_key: ENV['API_KEY'])
imdb_parser = Movienga::IMDBParser.new

collection = Movienga::MovieCollection.new(ENV['DATA_PATH'])
cacher = Movienga::Cacher.new(collection)

cacher.run(title: 'Caching TMDB Ru') { |item| tmdb_parser.parse(item.imdb_id) }
# cacher.run(title: 'Caching IMDB budgets') { |item| imdb_parser.parse(item.imdb_id) }

tmdb_parser.language = 'en'
cacher.run(title: 'Caching TMDB En') { |item| tmdb_parser.parse(item.imdb_id) }
