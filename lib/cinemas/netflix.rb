require_relative 'cinema'
require_relative '../movienga/cashbox'
require_relative '../errors'

class Netflix < Cinema
  include OnlineTheatre

  PRICE_LIST = {
    new: 5,
    modern: 3,
    classic: 1.5,
    ancient: 1
  }

  def initialize(filename, money_on_account = 0)
    super(filename)
    deposit(money_on_account)
  end

  def show(filter)
    movies = filter(filter)
    raise NothingToShow, filter unless movies.any?
    movie = peek_random(movies)
    withdraw PRICE_LIST[movie.period]
    puts show_movie(movie)
  end

  def how_much?(title)
    filter(title: title)
      .map { |m| [m.title, PRICE_LIST[m.period]] }.to_h
  end
end
