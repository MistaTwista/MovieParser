require 'date'

class Movie
  attr_reader :to_h

  def initialize(movie)
    @to_h = movie
  end

  def has_genre?(genre)
    result = to_h[:genre].include?(genre)
    raise "'#{title}' is not in genre #{genre}" unless result
    result
  end

  def month
    Date::MONTHNAMES[Date.strptime(to_h[:date], "%Y-%m").mon] rescue nil
  end

  def year
    Date.strptime(to_h[:year], "%Y").year
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
    "#{title} (#{year}; #{genre}) - #{length} min"
  end

  private

  def method_missing(name, *args)
    name = name.to_sym
    return to_h[name] if to_h.key?(name)
    super
  end
end
