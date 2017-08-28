require_relative '../lib/movie_collection'
require 'test/unit'

class TestMovieCollection < Test::Unit::TestCase
  def setup
    @movies = MovieCollection.new('tests/data/movies.txt')
  end

  def test_all
    assert_equal(250, @movies.all.count)
  end

  def test_sort_by
    assert_equal('Yojimbo', @movies.sort_by(:title).last.title)
    assert_equal('The Kid', @movies.sort_by(:year).first.title)
    assert_equal('Das Boot', @movies.sort_by(:country).last.title)
    assert_equal('Inside Out', @movies.sort_by(:date).last.title)
    assert_equal('Kill Bill: Vol. 1', @movies.sort_by(:genre).first.title)
    assert_equal('Gone with the Wind', @movies.sort_by(:length).last.title)
    assert_equal('Beauty and the Beast', @movies.sort_by(:rate).first.title)
    assert_equal('Departures', @movies.sort_by(:director).last.title)
    assert_equal('3 Idiots', @movies.sort_by(:actors).first.title)
  end

  def test_filter_director
    assert_equal(7, @movies.filter(director: 'Nolan').count)
    assert_equal(5, @movies.filter(actors: 'Brad Pitt').count)
    assert_equal(39, @movies.filter(genre: 'Comedy').count)
    assert_equal(7, @movies.filter(year: 1957).count)
    assert_equal(19, @movies.filter(month: 'January').count)
    assert_equal(166, @movies.filter(country: 'USA').count)
  end

  def test_stats_director
    assert_equal(7, @movies.stats(:director)['Christopher Nolan'])
    assert_equal(1, @movies.stats(:actors)['Heath Ledger'])
    assert_equal(4, @movies.stats(:year)[1984])
    assert_equal(18, @movies.stats(:month)['July'])
    assert_equal(23, @movies.stats(:genre)['Sci-Fi'])
    assert_equal(10, @movies.stats(:country)['France'])
  end
end
