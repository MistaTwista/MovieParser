require 'open-uri'
require 'nokogiri'
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
        budget = budget_nodes.first.text.strip.gsub(",","").match(/\$(\d*)/)
        # cache.update_data(
        #   id: imdb_id,
        #   group: language
        #   data: movie,
        #   file: url,
        # )
      end
    end

    private

    attr_reader :cache
  end
end
