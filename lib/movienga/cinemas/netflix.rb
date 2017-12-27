require 'money'
require_relative 'cinema'
require_relative '../cashbox'
require_relative '../errors'

module Movienga
  # Helper class for metaprogramming stuff. Used with {Netflix}
  class ByGenre
    def initialize(collection)
      @collection = collection
      create_methods(collection.genres)
    end

    private

    attr_reader :collection

    def create_methods(genres)
      genres.each do |genre|
        define_singleton_method(genre.downcase.to_sym) do
          collection.filter(genre: genre)
        end
      end
    end
  end

  # Helper class for metaprogramming stuff. Used with {Netflix}
  class ByCountry
    def initialize(collection)
      @collection = collection
    end

    private

    attr_reader :collection

    def method_missing(method, **args)
      if args.any?
        raise ArgumentError, "Method `#{method}` doesn't receive any arguments."
      end

      movies = collection.filter(country: /#{method}/i)

      return movies if movies.any?
      super
    end

    def respond_to_missing?(method, _include_private = false)
      collection.countries.any? { |country| country =~ /#{method}/i }
    end
  end

  # Imitation of online Cinema
  #
  # With shared cashbox ({#cash}), money account ({#pay}), flexible Filter
  # ({#filter}), custom filters ({#define_filter}) and also a bit of
  # metaprogramming {#by_genre} {by_country}
  class Netflix < Cinema
    extend Cashbox

    # Filter movies by genre
    #
    # @example Filter Comedies
    #   netflix.by_genre.comedy
    def by_genre
      ByGenre.new(self)
    end

    # Filter movies by country
    #
    # @example Filter USA movies
    #   netflix.by_country.usa
    def by_country
      ByCountry.new(self)
    end

    PRICE_LIST = {
      new: 5,
      modern: 3,
      classic: 1.5,
      ancient: 1
    }.freeze

    # @param filename [String] path to file.csv
    # @param money_on_account [Number] initial amount of money on users account
    def initialize(filename, money_on_account = 0)
      super(filename)
      pay(money_on_account)
    end

    # Show {#filter}ed movies
    #
    # Take your money, filter movie collection and show you some movie
    def show(**filters, &block)
      movies = filter(filters, &block)
      raise NothingToShow, filter unless movies.any?
      movie = peek_random(movies)
      withdraw_account PRICE_LIST[movie.period]
      puts show_movie(movie)
    end

    # Filter movies from collection
    #
    # @example with block usage
    #   netflix.filter { |movie| movie.title.include?('Terminator') }
    # @example with defined filter
    #   netflix.define_filter(:early) { |movie| movie.year < 2014 }
    #   netflix.filter(early: true)
    # @example complex filters
    #   netflix.define_filter(:style) { |m, genre| m.genre.include?(genre) }
    #   netflix.define_filter(:comedies, from: :style, arg: 'Comedy') do |movie|
    #     movie.year < 2014
    #   end
    #
    #   # Movies with year < 2014 and genre 'Comedy'
    #   netflix.filter(early: true, comedies: true)
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
      @countries ||= all.flat_map(&:country).uniq
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
