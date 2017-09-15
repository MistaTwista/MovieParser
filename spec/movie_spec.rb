require 'movie'

describe Movie do
  it_behaves_like 'a movie'
  include_context 'movie data'
  let(:movie) { Movie.new(modern_movie) }

  describe '#to_s' do
    it do
      expect(movie.to_s)
        .to eq 'The Shawshank Redemption (Tim Robbins, Morgan Freeman, Bob Gunton) 1994; Crime, Drama; 142 min'
    end
  end
end
