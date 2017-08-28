def puts_title(text)
  puts "\n\"#{text.upcase}\""
end

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/movie_collection'

movies = MovieCollection.new(filename)

puts_title 'All movies'
puts movies.all.count
puts_title 'Sort_by :length'
puts movies.sort_by(:length).last(5)
puts_title 'Has genre?'
begin
  puts movies.sort_by(:length).last.has_genre?('Comedy')
rescue RuntimeError => error
  puts error.message
end
puts_title 'Filter director: "Nolan"'
puts movies.filter(director: 'Nolan')
puts_title 'Stats Country'
puts movies.stats :country
