filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)

require 'csv'
require 'ostruct'
require 'date'

MOVIE_FIELDS = %i[url name year country
    release_date style length rate director cast].freeze

def format_movie(movie)
  "#{movie.name} (#{movie.year}; #{movie.style}) - #{movie.length}"
end

def title(text)
  puts "\n\"#{text.upcase}\""
end

movies = []
CSV.foreach(filename, { col_sep: '|' }) do |row|
  movies << OpenStruct.new(MOVIE_FIELDS.zip(row).to_h)
end

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
months = %i[january february march april may june july august september october november december]
stats = movies
  .select{ |movie| movie.release_date.match?(/\d{4}-(0[1-9]|1[0-2])/) }
  .reduce(Array.new(12, 0)) { |acc, movie|
    month = movie.release_date.split('-')[1].to_i - 1
    acc[month] += 1
    acc
  }
  .map.with_index{ |m, i|
    month = Date.strptime((i+1).to_s, '%m').strftime(format='%B')
    [month, m]
  }.to_h

puts stats
