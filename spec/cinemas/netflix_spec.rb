require 'movie_builder'
require 'cinemas/netflix'
require 'errors'

describe Movienga::Netflix do
  include_context 'movie data'

  let(:db_file) { 'spec/data/movies.txt' }
  let(:current_movie) { Movienga::MovieBuilder.build_movie(new_movie) }
  let(:netflix) { described_class.new(db_file) }
  let(:premium_netflix) { described_class.new(db_file, 100500) }
  let(:initial_money) { 10 }
  let(:collection) { [current_movie] }

  describe '#new' do
    before { described_class.send(:make_encashment) }
    let(:netflix) { described_class.new(db_file) }

    it do
      expect(described_class.cash).to eq 0
    end
  end

  describe '#shared cashbox' do
    before do
      described_class.send(:make_encashment)
      premium_netflix.account
      netflix.account
    end

    let(:netflix) { described_class.new(db_file, 500) }
    let(:premium_netflix) { described_class.new(db_file, 100500) }

    it do
      expect(described_class.cash).to eq money(101000)
    end
  end

  describe '#show' do
    before do
      described_class.send(:make_encashment)
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
        expect { netflix.show(genre: 'Comedy', period: :new) }
          .to raise_error Movienga::NothingToShow
      end
    end

    it do
      expect { netflix.show(genre: 'Comedy', period: :new) }
        .to output(/Dark Knight/).to_stdout
        .and change(netflix, :account).from(money(10)).to(money(5))
        .and not_change(described_class, :cash)
    end
  end

  describe '#pay' do
    before { described_class.send(:make_encashment) }

    it do
      expect { netflix.pay(10) }
        .to change(netflix, :account).from(money(0)).to(money(10))
        .and change(described_class, :cash).from(money(0)).to(money(10))
    end
  end

  describe '#how_much?' do
    it do
      expect(netflix.how_much? 'The Terminator')
        .to eq({ 'The Terminator' => 3 })
    end
  end
end
