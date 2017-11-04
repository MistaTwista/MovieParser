require 'money'
require_relative 'cinema'
require_relative '../cashbox'
require_relative '../errors'

module Movienga
  class HelperCinema
    attr_reader :collection

    def initialize(collection)
      @collection = collection
      create_methods(collection.genres)
    end

    def create_methods(genres)
      genres.each do |genre|
        mtd = ->() { collection.filter(genre: genre) }
        self.define_singleton_method(genre.downcase.to_sym, mtd)
      end
    end

    def method_missing(method, **args)
      movies = collection.filter(country: /#{method}/i)
      if movies.any? && args.any?
        raise ArgumentError.new(
          "Method `#{method}` doesn't receive any arguments."
        )
      end

      return movies if movies.any?
      super
    end

    def respond_to_missing?(method, include_private = false)
      collection.countries.select { |c| c =~ /#{method}/i }
    end
  end

  class Netflix < Cinema
    extend Cashbox

    def by_genre
      HelperCinema.new(self)
    end

    def by_country
      HelperCinema.new(self)
    end

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
      filter = prepare_filter(**filters, &block)
      super { |movie| filter.call(movie) }
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
      reusable_filter = curry_filter(defined_filters[from], arg) if from && arg
      defined_filters[filter_name] = reusable_filter || filter_proc
    end

    def countries
      @countries ||= all.map(&:country).flatten.uniq
    end

    private

    def prepare_filter(**filters, &block)
      defineds, natives = filters.partition { |n, _| defined_filters.key?(n) }
      combine_filters(
        [
          *defineds.map { |f, v| make_defined_filter(f, v) },
          *natives.map { |f, v| make_movie_filter(f, v) },
          block
        ].compact
      )
    end

    def make_defined_filter(key, value)
      filter = defined_filters.fetch(key)
      [true, false].include?(value) ? filter : curry_filter(filter, value)
    end

    def curry_filter(proc_to_curry, value)
      ->(object_to_check) { proc_to_curry.call(object_to_check, value) }
    end

    def combine_filters(filters)
      ->(object_to_check) { filters.all? { |p| p.call(object_to_check) } }
    end

    def make_movie_filter(field, value)
      ->(movie) { movie.matches?(field, value) }
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
