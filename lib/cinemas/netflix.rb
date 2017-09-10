require_relative 'cinema'

class Netflix < Cinema
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
    raise "Insufficient funds" if @account < amount
    @account -= amount
  end

  def price_for(movie)
    case movie.period
    when :new then 5
    when :modern then 3
    when :classic then 1.5
    when :ancient then 1
    end
  end
end
