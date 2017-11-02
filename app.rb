def puts_title(text)
  puts "\n\"#{text.upcase}\""
end

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/movienga/cinemas/netflix'
require_relative 'lib/movienga/cinemas/theatre'

netflix = Movienga::Netflix.new(filename)
netflix.pay(100)
netflix.define_filter(:early) { |m| m.year > 2014 }
netflix.define_filter(:actions) { |m| m.genre.include?('Action') }
netflix.define_filter(:gt_year) { |m, year| m.year > year }
netflix.define_filter(:style) { |m, genre| m.genre.include?(genre) }
netflix.define_filter(:comedies, from: :style, arg: 'Comedy')
netflix.show(early: true)
netflix.show(gt_year: 2014)
netflix.show(comedies: true)
netflix.show do |movie|
  !movie.title.include?('Terminator') &&
    movie.genre.include?('Action') &&
    movie.year > 2003
end
puts netflix.by_genre.comedy
puts netflix.by_genre.crime
puts netflix.by_country.usa

# puts "You have #{netflix.account}"
# netflix.show(genre: 'Comedy', period: :new)
# puts "You have #{netflix.account}"
# puts "Terminator cost #{netflix.how_much?(/The Terminator/)}"
#
# theatre = Movienga::Theatre.new(filename)
# theatre.show('13:45')
# when_to_show = theatre.when?('Life Is Beautiful')
# puts "'Life Is Beautiful' showing on #{when_to_show}"
