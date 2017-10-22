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

    def show(params = {}, &block)
      movies = filter(params, &block)
      raise NothingToShow, filter unless movies.any?
      movie = peek_random(movies)
      withdraw_account PRICE_LIST[movie.period]
      puts show_movie(movie)
    end

    def filter(params = {}, &block)
      selected_filter = select_filter(params, &block)
      super(selected_filter)
    end

    def select_filter(filter, &block)
      return block if block_given?
      user_filters = prepare_filters(filter)
      return user_filters.first if user_filters.any?
      filter
    end

    def prepare_filters(filter)
      filter.map do |key, value|
        if defined_filters[key]
          if [true, false].include?(value)
            defined_filters[key]
          else
            flip(defined_filters[key]).curry[value]
          end
        end
      end
    end

    def flip(flippable)
      proc { |first, second| flippable.(second, first) }
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

    def define_filter(filter_name, from: nil, arg: nil, &filter_proc)
      reusable_filter = if from && arg
        flip(defined_filters[from]).curry[arg]
      end

      defined_filters[filter_name] = reusable_filter || filter_proc
    end

    private

    def defined_filters
      @filters ||= {}
    end

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
