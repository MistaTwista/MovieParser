require 'movie_builder'
require 'cinemas/netflix'
require 'errors'

describe Netflix do
  include_context 'movie data'
  let(:movie_builder) { MovieBuilder.build_movie(new_movie) }

  let(:netflix) { Netflix.new('spec/data/movies.txt') }
  let(:premium_netflix) { Netflix.new('spec/data/movies.txt', 100500) }

  describe '#new' do
    it do
      expect(premium_netflix.account).to eq 100500
      expect(netflix.account).to eq 0
    end
  end

  describe '#show' do
    before { netflix.pay(10) }

    context 'when insufficient funds' do
      it do
        allow(STDOUT).to receive(:puts)
        expect { 5.times { netflix.show(genre: 'Drama') } }
          .to raise_error(RuntimeError, /Insufficient funds/)
      end
    end

    context 'when nothing to show' do
      it do
        allow(netflix).to receive(:filter)
          .and_return([])

        expect{ netflix.show(genre: 'Comedy', period: :new) }
          .to raise_error NothingToShow
      end
    end

    it do
      allow(netflix).to receive(:peek_random)
        .and_return(movie_builder)

      expect{ netflix.show(genre: 'Comedy', period: :new) }
        .to output(/Dark Knight/).to_stdout
        .and change(netflix, :account).from(10).to(5)
    end
  end

  describe '#pay' do
    it { expect { netflix.pay(10) }.to change{netflix.account}.from(0).to(10) }
  end

  describe '#how_much?' do
    it do
      expect(netflix.how_much? 'The Terminator').to eq [{"The Terminator" => 3}]
    end
  end
end
