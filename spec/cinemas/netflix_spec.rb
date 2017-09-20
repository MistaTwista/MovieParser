require 'movie_builder'
require 'cinemas/netflix'
require 'errors'

describe Netflix do
  include_context 'movie data'
  let(:current_movie) { MovieBuilder.build_movie(new_movie) }
  let(:netflix) { Netflix.new('spec/data/movies.txt') }
  let(:premium_netflix) { Netflix.new('spec/data/movies.txt', 100500) }
  let(:initial_money) { 10 }
  let(:collection) { [current_movie] }

  describe '#new' do
    it do
      expect(premium_netflix.account).to eq 100500
      expect(netflix.account).to eq 0
    end
  end

  describe '#show' do
    before do
      netflix.pay(initial_money)
      allow(netflix).to receive(:filter).and_return(collection)
    end

    context 'when insufficient funds' do
      let(:initial_money) { 0 }

      it do
        expect { netflix.show(genre: 'Drama') }
          .to raise_error(RuntimeError, /Insufficient funds/)
      end
    end

    context 'when nothing to show' do
      let(:collection) { [] }

      it do
        expect{ netflix.show(genre: 'Comedy', period: :new) }
          .to raise_error NothingToShow
      end
    end

    it do
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
