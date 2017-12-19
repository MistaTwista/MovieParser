require 'themoviedb-api'
require_relative './cache'

# TODO: TEST
module Movienga
  class TMDBParser
    def initialize(api_key:, language: 'ru', cache: Cache.new)
      @cache = cache
      self.language = language
      init_api(key: api_key)
    end

    def parse(imdb_id)
      movie = get_movie_info(imdb_id).first
      cache.persist_data(id: imdb_id, group: language, data: movie)

      url = path_to_image(movie.poster_path) if movie.poster_path
      cache.persist_file(id: imdb_id, group: language, file_url: url) if url
    end

    def language=(language)
      @language = language
      Tmdb::Api.language(language)
    end

    private

    attr_reader :language, :cache

    def init_api(key:, api: Tmdb::Api)
      api.key(key)
    end

    def get_movie_info(imdb_id)
      Tmdb::Find.movie(imdb_id, external_source: 'imdb_id')
    end

    def path_to_image(path, size = 'w300')
      "#{config.images.base_url}#{size}#{path}"
    end

    def config
      Tmdb::Configuration.get
    end
  end
end
