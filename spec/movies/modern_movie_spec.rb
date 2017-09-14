require 'movies_mock'
require 'movies/modern_movie'

describe ModernMovie do
  it_behaves_like 'a movie'
  include_context 'movies shared context'
  let(:movie_data) { MoviesMock::MODERN_MOVIE }

  describe '#to_s' do
    it do
      expect(movie.to_s)
        .to eq 'The Shawshank Redemption - modern movie. Actors: Tim Robbins, Morgan Freeman, Bob Gunton'
    end
  end

  describe '#period' do
    it { expect(movie.period).to eq :modern }
  end
end
