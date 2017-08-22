require './lib/movie_parser'

filename = ARGV[0] || 'movies.txt'

MoviesParser.new(filename).each do |movie|
  puts "#{movie.name} #{movie.rate}" if movie.name.match?(/Max/)
end
