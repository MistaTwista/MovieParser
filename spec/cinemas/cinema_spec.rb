require 'movie_builder'
require 'cinemas/cinema'
require 'timecop'

describe Cinema do
  it_behaves_like 'a cashbox'
  include_context 'movie data'

  let(:current_movie) { MovieBuilder.build_movie(ancient_movie) }
  let(:cinema) { Cinema.new('spec/data/movies.txt') }

  describe '#new' do
    it { expect(cinema.movies.class).to be Array }
  end

  describe '#show' do
    before { allow(cinema).to receive(:movies).and_return(movies) }
    subject { cinema.show }

    context 'when nothing to show' do
      let(:movies) { [] }
      it { expect { subject }.to raise_error NothingToShow }
    end

    context 'when exactly one movie' do
      let(:movies) { [current_movie] }
      before { Timecop.freeze(Time.parse('18:15')) }
      after { Timecop.return }

      it { expect { subject }.to output(/18:15/).to_stdout }
    end
  end
end
