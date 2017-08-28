require 'date'

class Movie
  attr_reader :to_h

  MOVIE_FIELDS = %i[url title year country
      date genre length rate director actors].freeze

  def initialize(movie)
    @to_h = movie
  end

  def has_genre?(genre)
    to_h[:genre].include?(genre)
  end

  def year
    to_h[:year].to_i
  end

  def length
    to_h[:length].to_i
  end

  def rate
    to_h[:rate].to_f
  end

  def genre
    to_h[:genre].split(',')
  end

  def actors
    to_h[:actors].split(',')
  end

  def date
    Date.strptime(to_h[:date]) rescue nil
  end

  def to_s
    "#{title} (#{year}; #{genre}) - #{length}"
  end

  private

  def method_missing(name, *args)
    name = name.to_sym
    return to_h[name] if to_h.key?(name)
    super
  end
end
