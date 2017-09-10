require 'date'

class Movie
  attr_reader :to_h

  def initialize(movie, collection = nil)
    @to_h = movie
    @collection = collection
  end

  def has_genre?(genre)
    raise "No #{genre} in a collection :(" unless collection_has_genre? genre
    self.genre.include?(genre)
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
    genre = self.genre.join(', ')
    actors = self.actors.join(', ')
    "#{title} (#{actors}) #{year}; #{genre}; #{length} min"
  end

  def period
    extract_period_from_movie_class
  end

  private

  def extract_period_from_movie_class
    movie_class = self.class.to_s
    movie_class.gsub(/([A-Z])/,'_\1').gsub(/^_/, '')
      .downcase.split('_').first.to_sym
  end

  def collection_has_genre?(genre)
    return true if @collection.nil?
    @collection.has_genre?(genre)
  end

  def method_missing(name, *args)
    name = name.to_sym
    return to_h[name] if to_h.key?(name)
    super
  end
end
