require 'movies_mock'
require 'movie_builder'
require 'cinemas/cinema'
require 'timecop'

describe Cinema do
  let(:movie_data) { MoviesMock::ANCIENT_MOVIE }
  let(:movie) { MovieBuilder.build_movie(movie_data) }
  let(:cinema) { Cinema.new('spec/data/movies.txt') }

  describe '#new' do
    it { expect(cinema.movies.class).to be Array }
  end

  describe '#show' do
    it do
      allow(cinema).to receive(:select_from_collection).and_return(movie)

      Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
        expect(cinema.show)
          .to eq "Now showing: Casablanca - ancient movie (1942) 18:15 - 19:57"
      end
    end
  end
end
