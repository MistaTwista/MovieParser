filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)

MOVIE_FIELDS = %w[url name year country
    release_date style length rate director cast].freeze

def format_movie(movie)
  "#{movie['name']} (#{movie['year']}; #{movie['style']}) - #{movie['length']}"
end

movies = IO.readlines(filename).map{ |l| l.strip.split('|') }
  .map { |m| Hash[MOVIE_FIELDS.zip(m)] }

puts "Five longest"
movies
  .sort{ |a, b| a['length'].to_i <=> b['length'].to_i }
  .pop(5)
  .each{ |movie| puts format_movie(movie) }

puts "10 earliest comedies"
movies
  .select{ |movie| movie['style'].split(',').include? 'Comedy' }
  .sort{ |a, b| a['year'].to_i <=> b['year'].to_i }
  .shift(5)
  .each{ |movie| puts format_movie(movie) }

puts "All directors"
movies
  .select{ |movie| !movie['director'].nil?  }
  .reduce([]){ |acc, el|
    director = el['director'].split.last
    acc.include?(director) ? acc << nil : acc << director
  }
  .compact
  .sort
  .each{ |d| puts d }

# puts "All directors with Set"
# require 'set'
# 
# movies
#   .select{ |movie| !movie['director'].nil?  }
#   .reduce([].to_set){ |acc, el| acc.add(el['director'].split.last) }
#   .to_a
#   .sort
#   .each{ |d| puts d }

puts "Non USA Movies"
puts movies.select{ |m| m['country'] != 'USA' }.count
