require 'movies_mock'
require 'movies/new_movie'

describe NewMovie do
  it_behaves_like 'a movie'

  let(:movie_data) { MoviesMock::NEW_MOVIE }
  let(:movie) { NewMovie.new(movie_data) }

  describe '#to_s' do
    it { expect(movie.to_s).to match /Dark Knight/ }
  end

  describe '#period' do
    it { expect(movie.period).to eq :new }
  end
end
