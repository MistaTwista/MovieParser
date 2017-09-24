shared_examples 'a cashbox for offline' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }
  let(:movie_name) { ('a'..'z').to_a.shuffle[0, 8].join }

  describe '#cash' do
    it { expect(cinema.cash).to eq money(0) }
  end

  describe '#take' do
    before { cinema.send(:deposit_cash, 10) }

    context 'when not bank' do
      it do
        expect { cinema.take(movie_name) }.to raise_error RuntimeError
      end
    end

    context 'when bank' do
      it do
        expect { cinema.take('Bank') }
          .to change(cinema, :cash).from(money(10)).to(money(0))
      end
    end
  end
end

shared_examples 'a cashbox for online' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }
  let(:movie_name) { ('a'..'z').to_a.shuffle[0, 8].join }
  before { described_class.send(:make_encashment) }

  describe '#cash' do
    it { expect(described_class.cash).to eq money(0) }
  end

  describe '#take' do
    before { described_class.send(:deposit_cash, 10) }

    context 'when not bank' do
      it do
        expect { described_class.take(movie_name) }.to raise_error RuntimeError
      end
    end

    context 'when bank' do
      it do
        expect { described_class.take('Bank') }
          .to change(described_class, :cash).from(money(10)).to(money(0))
      end
    end
  end
end
