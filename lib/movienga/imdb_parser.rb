require 'open-uri'
require 'nokogiri'
require 'yaml'
require_relative './cache'

module Movienga
  class IMDBParser
    def initialize(cache: Cache.new(group: 'common', file: 'imdb_data.yml'))
      @cache = cache
    end

    def parse(imdb_id)
      doc = get_page_by(imdb_id)
      budget_nodes = doc.css('div#titleDetails div.txt-block')
                        .select { |n| n.text.include?('Budget') }

      return nil unless budget_nodes.any?

      budget = budget_nodes.first.text.strip
                           .delete(',').match(/\A(Budget:)(.*)\n/)[2]

      cache.persist(id: imdb_id, data: { budget: budget })
    end

    private

    attr_reader :cache

    def get_page_by(imdb_id, html_parser: Nokogiri::HTML)
      html_parser(open("http://www.imdb.com/title/#{imdb_id}"))
    end
  end
end
