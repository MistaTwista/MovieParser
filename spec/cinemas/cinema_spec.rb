require 'movie_builder'
require 'cinemas/cinema'
require 'timecop'

describe Cinema do
  include_context 'movie data'
  let(:movie_builder) { MovieBuilder.build_movie(ancient_movie) }
  let(:cinema) { Cinema.new('spec/data/movies.txt') }

  describe '#new' do
    it { expect(cinema.movies.class).to be Array }
  end

  describe '#show' do
    context 'when nothing to show' do
      it do
        allow(cinema).to receive(:movies).and_return([])
        expect { cinema.show }.to raise_error NothingToShow
      end
    end

    it do
      allow(cinema).to receive(:peek_random)
        .and_return(movie_builder)

      Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
        expect { cinema.show }.to output(/ancient/).to_stdout
      end
    end
  end
end
