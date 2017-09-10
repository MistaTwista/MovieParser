require 'movies_mock'
require 'movie_builder'
require 'cinemas/cinema'

describe Cinema do
  let(:movie) { MovieBuilder.build_movie(MoviesMock::ANCIENT_MOVIE) }
  let(:cinema) { Cinema.new('spec/data/movies.txt') }

  describe '#new' do
    it { expect(cinema.movies.class).to be Array }
  end

  describe '#show' do
    it do
      allow(cinema).to receive(:select_from_collection).and_return(movie)
      expect(cinema.show).to eq "Now showing: Casablanca - ancient movie (1942)"
    end
  end
end
