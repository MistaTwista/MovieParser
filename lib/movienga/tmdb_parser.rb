require 'themoviedb-api'
require 'open-uri'
require 'yaml'

module Movienga
  class Cache
    def initialize(base_folder = 'cache')
      @base_folder = base_folder
    end

    def persist_data(id:, data:, image_url:, language:)
      download_file(image_url, id)
      path = path_to(id)
      filename = "#{path}/data.yml"
      raise "Cannot download file to #{path}" unless good_path?(path)
      File.new(filename, "w+") unless File.exists?(filename)
      File.open(filename, "r+") { |f| f.write(data.to_yaml) }
    end

    def get_data(id)
      filename = "#{path_to(id)}/data.yml"
      raise "#{filename} not found" unless File.exists?(filename)
      YAML.load_file(filename)
    end

    private

    def path_to(id)
      "#{@base_folder}/#{id}/#{language}"
    end

    def good_path?(folder)
      system 'mkdir', '-p', folder
    end

    def download_file(url, id)
      base = path_to(id)
      filename = "#{base}/poster.jpg"
      raise "Cannot download file to #{filename}" unless good_path?(base)
      open(filename, 'wb') do |file|
        file << open(url).read
      end
    end
  end

  class TMDBParser
    def initialize(api_key:, language: 'ru', cache:)
      @cache = cache || Cache.new(group: language) # TODO: Cache language
      @language = language
      init_api(key: api_key)
      set_language(language)
    end

    def parse(imdb_id)
      movie = get_movie_info(imdb_id).first
      url = path_to_image(movie.poster_path)
      cache.persist_data(
        id: imdb_id,
        data: movie,
        image_url: url,
        language: language
      )
    end

    def set_language(language)
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
