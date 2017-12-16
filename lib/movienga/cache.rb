require 'open-uri'
require 'pry'

# TODO: Make cache importable
module Movienga
  class Cache
    def initialize(base_folder: 'cache')
      @base_folder = base_folder
    end

    def persist_data(id:, group:, data:)
      path = base_path_to(id: id, group: group)
      raise "Cannot put data to #{path}" unless good_path?(path)
      filename = "#{path}/data.yml"

      File.new(filename, "w+") unless File.exists?(filename)
      File.open(filename, "r+") { |f| f.write(data.to_yaml) }
    end

    def persist_file(id:, group:, file:)
      path = base_path_to(id: id, group: group)
      raise "Cannot put data to #{path}" unless good_path?(path)
      filename = "#{path}/poster.jpg"

      raise "#{filename} already exists" if File.exists?(filename)
      download_file(file, path)
    end

    def get_data(id:, group: 'ru')
      path = base_path_to(id: id, group: group)
      filename = "#{path}/data.yml"
      raise "#{filename} not found" unless File.exists?(filename)
      YAML.load_file(filename)
    end

    def get_file_path(id:, group: 'ru')
      path = base_path_to(id: id, group: group)
      "#{path}/poster.jpg"
    end

    private

    def base_path_to(id:, group:)
      "#{@base_folder}/#{id}/#{group}"
    end

    def good_path?(folder)
      system 'mkdir', '-p', folder
    end

    def download_file(url, path)
      filename = "#{path}/poster.jpg"
      raise "Cannot download file to #{filename}" unless good_path?(path)
      open(filename, 'wb') { |file| file << open(url).read }
    end
  end
end
