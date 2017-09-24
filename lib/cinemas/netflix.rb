require 'money'
require_relative 'cinema'
require_relative '../movienga/cashbox'
require_relative '../errors'

module Movienga
  class Netflix < Cinema
    extend Cashbox

    PRICE_LIST = {
      new: 5,
      modern: 3,
      classic: 1.5,
      ancient: 1
    }

    def initialize(filename, money_on_account = 0)
      super(filename)
      pay(money_on_account)
    end

    def show(filter)
      movies = filter(filter)
      raise NothingToShow, filter unless movies.any?
      movie = peek_random(movies)
      withdraw_account PRICE_LIST[movie.period]
      puts show_movie(movie)
    end

    def how_much?(title)
      filter(title: title)
        .map { |m| [m.title, PRICE_LIST[m.period]] }.to_h
    end

    def pay(amount)
      deposit_account(amount)
    end

    def account
      @account || money(0)
    end

    private

    def account=(amount)
      @account = money(amount)
    end

    def deposit_account(amount)
      amount = money(amount)
      self.account += amount
      self.class.deposit_cash(amount)
    end

    def withdraw_account(amount)
      amount = money(amount)
      validate_enough!(amount)
      self.account -= amount
    end

    def validate_enough!(amount)
      amount = money(amount)

      if account < amount
        raise "Insufficient funds. Cost #{amount} and you have #{account}"
      end
    end
  end
end
