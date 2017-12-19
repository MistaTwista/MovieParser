require 'open-uri'
require 'pry'

module Movienga
  class Cache # TODO: FileCacher, YMLCacher
    def initialize(base_folder: 'cache')
      @base_folder = base_folder
    end

    def persist_data(id:, group:, file: 'data.yml', data:)
      file_path = base_path_to(id: id, group: group, file: file)
      raise "Cannot put data to #{file_path}" unless good_path_for?(file_path)

      File.new(file_path, "w+") unless File.exists?(file_path)
      File.open(file_path, "r+") { |f| f.write(data.to_yaml) }
    end

    def persist_file(id:, group:, file: 'poster.jpg', file_url:)
      file_path = base_path_to(id: id, group: group, file: file)
      raise "Cannot put data to #{file_path}" unless good_path_for?(file_path)
      raise "#{file_path} already exists" if File.exists?(file_path)

      download_file(file_url, file_path)
    end

    def get_data(id:, group: 'ru', file: 'data.yml')
      file_path = base_path_to(id: id, group: group, file: file)
      raise "#{file_path} not found" unless File.exists?(file_path)

      YAML.load_file(file_path)
    end

    def get_file_path(id:, group: 'ru', file: 'poster.jpg')
      base_path_to(id: id, group: group, file: file)
    end

    private

    attr_reader :base_folder

    def base_path_to(id:, group:, file:)
      "#{base_folder}/#{id}/#{group}/#{file}"
    end

    def good_path_for?(file)
      folder = file.split('/').slice(0...-1).join('/')
      system 'mkdir', '-p', folder
    end

    def download_file(url, file_path)
      unless good_path_for?(file_path)
        raise "Cannot download file to #{file_path}"
      end

      open(file_path, 'wb') { |file| file << open(url).read }
    end
  end
end
