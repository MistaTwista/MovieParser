class MoviesParser
  attr_reader :filename
  attr_reader :movies

  MOVIE_FIELDS = %w[url name year country
                    release_date style length rate director cast].freeze

  def initialize(filename = 'movies.txt')
    @filename = filename
    @movies = []

    if invalid_filename?
      bad_filename
      return
    end

    @movies = data_from_filename
  end

  def each(&block)
    movies.each(&block)
  end

  private

  def data_from_filename
    IO.readlines(filename).map { |line| prepare_data line.strip.split('|') }
  end

  def prepare_data(movie_data)
    hash = Hash[MOVIE_FIELDS.zip(movie_data)]
    Movie.new(hash)
  end

  def invalid_filename?
    filename.nil? || !File.readable?(filename)
  end

  def bad_filename
    puts "File #{filename} is not exists or can't be read"
  end
end

class Movie
  attr_reader :to_h

  MIN_RATE = 8

  def initialize(hash)
    @to_h = hash
  end

  def rate
    calculated_rate.positive? ? '*' * calculated_rate : '"No rate"'
  end

  private

  def calculated_rate
    return 0 unless to_h.key?('rate')
    ((to_h['rate'].to_f * 10).to_i - MIN_RATE * 10)
  end

  def method_missing(name, *args)
    name = name.to_s
    return to_h[name] if to_h.key?(name)
    super
  end
end
