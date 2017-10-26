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

    def show(**filters, &block)
      movies = filter(filters, &block)
      raise NothingToShow, filter unless movies.any?
      movie = peek_random(movies)
      withdraw_account PRICE_LIST[movie.period]
      puts show_movie(movie)
    end

    def filter(**filters, &block)
      selected = select_filter(**filters, &block)
      return super { |movie| selected.call(movie) } if selected.is_a? Proc
      super(selected)
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
                          curry_second_proc_value(defined_filters[from], arg)
                        end

      defined_filters[filter_name] = reusable_filter || filter_proc
    end

    private

    def select_filter(**filter, &block)
      return block if block_given?
      user_filters = select_from_defined(filter)
      return combine_filters(user_filters) if user_filters.any?
      filter
    end

    def select_from_defined(filter)
      filter.reject { |key, _| defined_filters[key].nil? }
            .map do |key, value|
              if [true, false].include?(value)
                defined_filters[key]
              else
                curry_second_proc_value(defined_filters[key], value)
              end
            end.compact
    end

    def curry_second_proc_value(proc_to_curry, value)
      proc { |object_to_check| proc_to_curry.call(object_to_check, value) }
    end

    def combine_filters(filters)
      proc { |object_to_check| filters.all? { |p| p.call(object_to_check) } }
    end

    def defined_filters
      @defined_filters ||= {}
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
