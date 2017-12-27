require 'open-uri'
require 'fileutils'

module Movienga
  # Persist data in YAML files
  #
  # Allows to {#persist} to file and {#get} data back
  class Cache
    # @param base_folder [String] Base folder for cache
    # @param group [String] Group of data
    # @param file [String] Filename for saveable data
    # @example
    #   c = Cache.new(base_folder: 'cache', group: 'common', file: 'data.yml')
    #   c.persist 't1000', { some: 'Data', to: 'save' }
    #   # will put data to 'cache/t1000/common/data.yml'
    def initialize(base_folder: 'cache', group: 'common', file: 'data.yml')
      @base_folder = base_folder
      @group = group
      @file = file
    end

    # Persist data to id
    #
    # @param id [#to_s] Storage id of saveable data
    # @param data [#to_yaml] Data to save to cache
    def persist(id, **data)
      file_path = base_path_to(id)
      create_storage(file_path) unless folder_ready?(file_path)
      File.new(file_path, 'w+') unless File.exist?(file_path)
      File.open(file_path, 'r+') { |f| f.write(data.to_yaml) }
    end

    # Get data by id
    #
    # @param id [#to_s] Storage id of data
    def get(id)
      file_path = base_path_to(id)
      raise "#{file_path} not found" unless File.exist?(file_path)

      YAML.load_file(file_path)
    end

    # Clear cache
    def clear
      FileUtils.rm_rf base_folder
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

  # Download file to storage
  class FileCache < Cache
    # Persist data to id
    #
    # @param file_url [String] URL to file
    # @param id [#to_s] Storage id of file to download
    def persist(id, file_url:)
      file_path = base_path_to(id)
      create_storage(file_path) unless folder_ready?(file_path)
      raise "#{file_path} already exists" if File.exist?(file_path)

      download_file(file_url, file_path)
    end

    # Get data by id
    #
    # @param id [#to_s] Storage id of file
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
