def puts_title(text)
  puts "\n\"#{text.upcase}\""
end

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/movienga/cinemas/netflix'
require_relative 'lib/movienga/cinemas/theatre'

netflix = Movienga::Netflix.new(filename)
netflix.pay(10)
netflix.define_filter(:late) { |m| m.year > 2003 }
netflix.define_filter(:action) { |m| m.genre.include?('Action') }
# puts "You have #{netflix.account}"
# netflix.show(genre: 'Comedy', period: :new)
# puts "You have #{netflix.account}"
# puts "Terminator cost #{netflix.how_much?(/The Terminator/)}"
# netflix.show do |movie|
#   !movie.title.include?('Terminator') &&
#   movie.genre.include?('Action') &&
#   movie.year > 2003
# end
#
# theatre = Movienga::Theatre.new(filename)
# theatre.show('13:45')
# when_to_show = theatre.when?('Life Is Beautiful')
# puts "'Life Is Beautiful' showing on #{when_to_show}"
