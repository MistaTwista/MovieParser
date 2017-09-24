require 'movienga/movie_builder'
require 'movienga/cinemas/cinema'
require 'timecop'

describe Movienga::Cinema do
  include_context 'movie data'

  let(:current_movie) { Movienga::MovieBuilder.build_movie(ancient_movie) }
  let(:cinema) { described_class.new('spec/data/movies.txt') }

  describe '#new' do
    it { expect(cinema.movies.class).to be Array }
  end

  describe '#show' do
    before { allow(cinema).to receive(:movies).and_return(movies) }
    subject { cinema.show }

    context 'when nothing to show' do
      let(:movies) { [] }
      it { expect { subject }.to raise_error Movienga::NothingToShow }
    end

    context 'when exactly one movie' do
      let(:movies) { [current_movie] }
      before { Timecop.freeze(Time.parse('18:15')) }
      after { Timecop.return }

      it { expect { subject }.to output(/18:15/).to_stdout }
    end
  end
end
