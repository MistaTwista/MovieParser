filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)

MOVIE_FIELDS = %i[url name year country
    release_date style length rate director cast].freeze

def format_movie(movie)
  "#{movie[:name]} (#{movie[:year]}; #{movie[:style]}) - #{movie[:length]}"
end

movies = IO.readlines(filename).map{ |l| l.strip.split('|') }
  .map { |m| MOVIE_FIELDS.zip(m).to_h }

puts "Five longest"
movies
  .sort_by{ |m| m[:length].to_i }
  .last(5)
  .each{ |movie| puts format_movie(movie) }

puts "10 earliest comedies"
movies
  .select{ |movie| movie[:style].split(',').include? 'Comedy' }
  .sort_by{ |m| m[:year].to_i }
  .first(5)
  .each{ |movie| puts format_movie(movie) }

puts "All directors"
movies
  .map{ |movie| movie[:director] }
  .sort_by{ |director| director.split.last  }
  .uniq.each{ |d| puts d }

puts "Non USA Movies"
puts movies.select{ |m| m['country'] != 'USA' }.count
