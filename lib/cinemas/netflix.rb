require_relative 'cinema'

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

  def show(options)
    @movie = select_from_collection filter(options)
    raise NothingToShow unless movie
    withdraw PRICE_LIST[movie.period]
    puts show_movie 
  end

  def pay(amount)
    @account += amount
  end

  def how_much?(title)
    movies = filter(title: title)
    movies.map { |m| { m.title => PRICE_LIST[m.period] } } if movies.any?
  end

  private

  def withdraw(amount)
    raise insufficient_message(amount) if @account < amount
    @account -= amount
  end

  def insufficient_message(amount)
    "Insufficient funds. Cost #{amount} and you have #{account}"
  end
end
