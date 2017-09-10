require 'movies_mock'
require 'movie_builder'
require 'cinemas/netflix'

describe Netflix do
  let(:mock) { MoviesMock::NEW_MOVIE }
  let(:movie) { MovieBuilder.build_movie(mock) }
  let(:netflix) { Netflix.new('spec/data/movies.txt') }
  let(:premium_netflix) { Netflix.new('spec/data/movies.txt', 100500) }

  describe '#new' do
    it do
      expect(premium_netflix.account).to eq 100500
      expect(netflix.account).to eq 0
    end
  end

  describe '#show' do
    context 'when insufficient funds' do
      it do
        expect { netflix.show(genre: 'Drama') }.to raise_error RuntimeError
      end
    end

    it do
      allow(netflix).to receive(:select_from_collection).and_return(movie)
      allow(movie).to receive(:this_year).and_return(2017)

      netflix.pay(10)
      expect{ netflix.show(genre: 'Comedy', period: :new) }
        .to output(/Dark Knight/).to_stdout
    end
  end

  describe '#pay' do
    it { expect { netflix.pay(10) }.to change{netflix.account}.from(0).to(10) }
  end

  describe '#how_much?' do
    it { expect(netflix.how_much? 'The Terminator').to eq 3 }
  end
end
