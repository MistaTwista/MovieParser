def puts_title(text)
  puts "\n\"#{text.upcase}\""
end

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/cinemas/netflix'
require_relative 'lib/cinemas/theatre'

netflix = Netflix.new(filename)
netflix.pay(10)
puts "You have #{netflix.account}"
netflix.show(genre: 'Comedy', period: :new)
puts "You have #{netflix.account}"
puts "Terminator cost #{netflix.how_much?(/[A-Z]/)}"

theatre = Theatre.new(filename)
theatre.show('13:45')
when_to_show = theatre.when?('Life Is Beautiful')
puts "'Life Is Beautiful' showing on #{when_to_show.join(' and ')}"
