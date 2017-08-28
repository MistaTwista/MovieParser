require 'csv'

class CsvToHash
  attr_reader :data

  def initialize(filename, headers)
    @data = CSV.foreach(filename, { col_sep: '|', headers: headers }).map &:to_h
  end
end
