require 'movies_mock'
require 'movies/ancient_movie'

describe AncientMovie do
  it_behaves_like 'a movie'

  let(:movie_mock) { MoviesMock::ANCIENT_MOVIE }
  let(:movie) { AncientMovie.new(movie_mock) }

  describe '#to_s' do
    it { expect(movie.to_s).to eq 'Casablanca - ancient movie (1942)' }
  end
end
