require 'movies_mock'
require 'movies/ancient_movie'

describe AncientMovie do
  it_behaves_like 'a movie'
  include_context 'movies shared context'
  let(:movie_data) { MoviesMock::ANCIENT_MOVIE }

  describe '#to_s' do
    it { expect(movie.to_s).to eq 'Casablanca - ancient movie (1942)' }
  end

  describe '#period' do
    it { expect(movie.period).to eq :ancient }
  end
end
