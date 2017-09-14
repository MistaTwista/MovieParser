require 'movie'
require 'movies_mock'

describe Movie do
  it_behaves_like 'a movie'

  let(:movie_data) { MoviesMock::MODERN_MOVIE }
  let(:movie) { Movie.new(movie_data) }

  describe '#to_s' do
    it do
      expect(movie.to_s)
        .to eq 'The Shawshank Redemption (Tim Robbins, Morgan Freeman, Bob Gunton) 1994; Crime, Drama; 142 min'
    end
  end
end
