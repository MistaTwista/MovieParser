require_relative 'cinema'

class Netflix < Cinema
  NEW_COST = 5
  MODERN_COST = 3
  CLASSIC_COST = 1.5
  ANCIENT_COST = 1

  attr_reader :account

  def initialize(filename, money_on_account = 0)
    @account = money_on_account
    super(filename)
  end

  def show(options)
    @movie = select_from_collection filter(options)
    withdraw price_for movie
    puts show_movie
  end

  def pay(amount)
    @account += amount
  end

  def how_much?(title)
    movies = filter(title: title)
    price_for(movies.first) if movies.any?
  end

  private

  def withdraw(amount)
    raise insufficient_message(amount) if @account < amount
    @account -= amount
  end

  def insufficient_message(amount)
    "Insufficient funds. Cost #{amount} and you have #{account}"
  end

  def price_for(movie)
    case movie.period
    when :new then NEW_COST
    when :modern then MODERN_COST
    when :classic then CLASSIC_COST
    when :ancient then ANCIENT_COST
    end
  end
end
