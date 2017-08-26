filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)

require 'csv'
require 'ostruct'
require 'date'
require 'irb'

MOVIE_FIELDS = %i[url name year country
    date style length rate director cast].freeze

def format_movie(movie)
  "#{movie.name} (#{movie.year}; #{movie.style}) - #{movie.length}"
end

def title(text)
  puts "\n\"#{text.upcase}\""
end

movies = CSV.foreach(filename, { col_sep: '|', headers: MOVIE_FIELDS })
  .map { |row| OpenStruct.new(row.to_h) }

title 'Five longest'
movies
  .sort_by{ |m| m.length.to_i }
  .last(5)
  .each{ |movie| puts format_movie(movie) }

title '10 earliest comedies'
movies
  .select{ |movie| movie.style.split(',').include? 'Comedy' }
  .sort_by{ |m| m.year.to_i }
  .first(5)
  .each{ |movie| puts format_movie(movie) }

title 'All directors'
movies
  .map{ |movie| movie.director }
  .sort_by{ |director| director.split.last  }
  .uniq.each{ |d| puts d }

title 'Non USA Movies'
puts movies.select{ |m| m.country != 'USA' }.count

title 'Month stats'
stats = movies
  .map{ |m| Date.strptime(m.date, '%Y-%m').mon rescue nil }
  .compact
  .group_by(&:itself)
  .sort
  .map {|month, movies| [Date::MONTHNAMES[month], movies.count]}
  .to_h

puts stats
