def puts_title(text)
  puts "\n\"#{text.upcase}\""
end

filename = ARGV[0] || 'movies.txt'
abort("#{filename} not found or can't be read") unless File.readable?(filename)
require_relative 'lib/movienga/cinemas/netflix'
require_relative 'lib/movienga/cinemas/theatre'

netflix = Movienga::Netflix.new(filename)
netflix.pay(100)
# puts netflix.by_country.usa(make: :lol)

# theatre = Movienga::Theatre.new(filename)
# theatre.show('13:45')
# when_to_show = theatre.when?('Life Is Beautiful')
# puts "'Life Is Beautiful' showing on #{when_to_show}"

theatre = Movienga::Theatre.new(filename) do
  hall :red, titile: 'Red hall', places: 100
  hall :blue, title: 'Blue hall', places: 50
  hall :green, title: 'Green hall (VIP)', places: 12

  period '09:00'..'11:00' do
    description 'Morning movies'
    filters genre: 'Comedy', year: 1900..1980
    price 10
    hall :red, :blue
  end

  period '11:00'..'16:00' do
    description 'Specials'
    filters title: 'The Terminator'
    price 50
    hall :green
  end

  period '16:00'..'20:00' do
    description 'Evening movies'
    filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
    price 20
    hall :red, :blue
  end

  period '19:00'..'22:00' do
    description 'Night zone'
    filters year: 1900..1945, exclude_country: 'USA'
    price 30
    hall :green
  end
end
