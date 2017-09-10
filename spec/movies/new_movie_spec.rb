require 'movies_mock'
require 'movies/new_movie'

describe NewMovie do
  it_behaves_like 'a movie'

  let(:movie_mock) { MoviesMock::NEW_MOVIE }
  let(:movie) { NewMovie.new(movie_mock) }

  describe '#to_s' do
    it do
      allow(movie).to receive(:this_year).and_return(2017)
      expect(movie.to_s).to eq 'The Dark Knight - new movie! 9 years ago'
    end
  end
end
