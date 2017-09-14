require 'movies_mock'
require 'movies/classic_movie'

describe ClassicMovie do
  it_behaves_like 'a movie'
  include_context 'movies shared context'
  let(:movie_data) { MoviesMock::CLASSIC_MOVIE }

  describe '#to_s' do
    it do
      allow(movie)
        .to receive(:other_directors_movies).and_return('Some, Other, Movies')
      expect(movie.to_s)
        .to eq '12 Angry Men - classic movie, director: Sidney Lumet, also: Some, Other, Movies'
    end
  end

  describe '#period' do
    it { expect(movie.period).to eq :classic }
  end
end
