require 'open-uri'
require 'fileutils'

module Movienga
  class Cache
    def initialize(base_folder: 'cache', group: 'common', file: 'data.yml')
      @base_folder = base_folder
      @group = group
      @file = file
    end

    def persist(id, **data)
      file_path = base_path_to(id)
      create_storage(file_path) unless folder_ready?(file_path)
      File.new(file_path, 'w+') unless File.exist?(file_path)
      File.open(file_path, 'r+') { |f| f.write(data.to_yaml) }
    end

    def get(id)
      file_path = base_path_to(id)
      raise "#{file_path} not found" unless File.exist?(file_path)

      YAML.load_file(file_path)
    end

    def clear
      system 'rm', '-rf', base_folder
    end

    private

    attr_reader :base_folder, :group, :file

    def base_path_to(id)
      "#{base_folder}/#{id}/#{group}/#{file}"
    end

    def extract_folder_path(file_path)
      file_path.split('/').slice(0...-1).join('/')
    end

    def folder_ready?(file_path)
      File.directory? extract_folder_path(file_path)
    end

    def create_storage(file_path)
      FileUtils.mkdir_p extract_folder_path(file_path)
    end
  end

  class FileCache < Cache
    def persist(id, file_url:)
      file_path = base_path_to(id)
      create_storage(file_path) unless folder_ready?(file_path)
      raise "#{file_path} already exists" if File.exist?(file_path)

      download_file(file_url, file_path)
    end

    def get(id)
      base_path_to(id)
    end

    private

    def download_file(url, file_path)
      unless good_path_for?(file_path)
        raise "Cannot download file to #{file_path}"
      end

      open(file_path, 'wb') { |file| file << open(url).read }
    end
  end
end
