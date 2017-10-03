require 'money'
require_relative 'cinema'
require_relative '../cashbox'
require_relative '../errors'

module Movienga
  class Netflix < Cinema
    extend Cashbox

    PRICE_LIST = {
      new: 5,
      modern: 3,
      classic: 1.5,
      ancient: 1
    }.freeze

    def initialize(filename, money_on_account = 0)
      super(filename)
      pay(money_on_account)
    end

    def show(filter = {}, &filter_proc)
      filterable = block_given? ? filter_proc : filter
      movies = filter(filterable)
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

    def define_filter(filter_name, &filter_proc)
      @filters ||= {}
      @filters[filter_name] = filter_proc
      binding.irb
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
      return if account > money(amount)
      raise "Insufficient funds. Cost #{amount} and you have #{account}"
    end

    def money(amount)
      self.class.money(amount)
    end
  end
end
