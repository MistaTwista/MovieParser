require 'themoviedb-api'
require_relative './cache'

module Movienga
  # Parse TMDB API and put data to {Cache}. Download poster to {FileCache}.
  class TMDBParser
    attr_reader :language

    def initialize(api_key:, language: 'ru', poster_cache: nil, data_cache: nil)
      @poster_cache = poster_cache ||
                      FileCache.new(group: language, file: 'poster.jpg')
      @data_cache = data_cache ||
                    Cache.new(group: language)
      @language = language
      init_api(key: api_key)
    end

    def parse(imdb_id)
      movie = get_movie_info(imdb_id).first
      data_cache.persist(id: imdb_id, data: movie)

      url = path_to_image(movie.poster_path) if movie.poster_path
      poster_cache.persist(id: imdb_id, file_url: url) if url
    end

    private

    attr_reader :poster_cache, :data_cache

    def init_api(key:, api: Tmdb::Api)
      api.key(key)
      api.language(language)
    end

    def path_to_image(path, size = 'w300')
      "#{api_config.images.base_url}#{size}#{path}"
    end

    def get_movie_info(imdb_id, api: Tmdb::Find)
      api.movie(imdb_id, external_source: 'imdb_id')
    end

    def api_config(api_config: Tmdb::Configuration)
      api_config.get
    end
  end
end
