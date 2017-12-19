require 'open-uri'
require 'nokogiri'
require 'yaml'
require_relative './cache'

module Movienga
  class IMDBParser
    def initialize(cache: Cache.new)
      @cache = cache
    end

    def parse(imdb_id)
      doc = Nokogiri::HTML open("http://www.imdb.com/title/#{imdb_id}")
      budget_nodes = doc.css("div#titleDetails div.txt-block")
                  .select{|n| n.text.include?("Budget")}
      if budget_nodes.any?
        budget = budget_nodes.first.text.strip
          .gsub(",","").match(/\A(Budget:)(.*)\n/)[2]

        cache.persist_data(
          id: imdb_id,
          group: 'common',
          file: 'imdb_data.yml',
          data: { budget: budget }
        )
      end
    end

    private

    attr_reader :cache
  end
end
