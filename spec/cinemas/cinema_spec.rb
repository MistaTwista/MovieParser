require 'movie_builder'
require 'cinemas/cinema'
require 'timecop'

describe Cinema do
  include_context 'movie data'
  let(:current_movie) { MovieBuilder.build_movie(ancient_movie) }
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
        .and_return(current_movie)

      Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
        expect { cinema.show }.to output(/18:15/).to_stdout
      end
    end
  end
end
