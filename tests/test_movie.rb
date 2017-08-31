require_relative '../lib/movie_collection'
require 'test/unit'

module MovieMock
  def self.genre
    "Drama"
  end
end

module MovieCollectionMock
  def self.all
    [MovieMock]
  end
end

class TestMovie < Test::Unit::TestCase
  def setup
    movie = {
      url: "http://imdb.com/title/tt0052561/?ref_=chttp_tt_247",
      title: "Anatomy of a Murder",
      year: "1959",
      country: "USA",
      date: "1959-09-10",
      genre: "Crime,Drama,Mystery",
      length: "160 min",
      rate: "8.1",
      director: "Otto Preminger",
      actors: "James Stewart,Lee Remick,Ben Gazzara"
    }

    @movie = Movie.new(movie)
    @movie_with_collection = Movie.new(movie, MovieCollectionMock)
  end

  def test_has_genre
    assert_equal(true, @movie.has_genre?('Drama'))

    assert_raise(RuntimeError) do
      @movie_with_collection.has_genre?('Cmedy')
    end
  end

  def test_title
    assert_equal('Anatomy of a Murder', @movie.title)
  end

  def test_year
    assert_equal(1959, @movie.year)
  end

  def test_country
    assert_equal('USA', @movie.country)
  end

  def test_date
    assert_equal('10-09-1959', @movie.date.strftime('%d-%m-%Y'))
  end

  def test_genre
    assert_equal(["Crime", "Drama", "Mystery"], @movie.genre)
  end

  def test_length
    assert_equal(160, @movie.length)
  end

  def test_rate
    assert_equal(8.1, @movie.rate)
  end

  def test_director
    assert_equal('Otto Preminger', @movie.director)
  end

  def test_actors
    assert_equal(['James Stewart', 'Lee Remick', 'Ben Gazzara'], @movie.actors)
  end

  def test_month
    assert_equal('September', @movie.month)
  end
end
