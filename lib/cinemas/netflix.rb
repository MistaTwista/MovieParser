require_relative 'cinema'
require_relative '../errors'

class Netflix < Cinema
  PRICE_LIST = {
    new: 5,
    modern: 3,
    classic: 1.5,
    ancient: 1
  }

  attr_reader :account

  def initialize(filename, money_on_account = 0)
    @account = money_on_account
    super(filename)
  end

  def show(filter)
    movies = filter(filter)
    raise NothingToShow, filter unless movies.any?
    movie = peek_random(movies)
    withdraw PRICE_LIST[movie.period]
    puts show_movie(movie)
  end

  def pay(amount)
    @account += amount
  end

  def how_much?(title)
    filter(title: title)
      .map { |m| [m.title, PRICE_LIST[m.period]] }.to_h
  end

  private

  def withdraw(amount)
    validate_enough!(amount)
    @account -= amount
  end

  def validate_enough!(amount)
    if account < amount
      raise "Insufficient funds. Cost #{amount} and you have #{account}"
    end
  end
end
