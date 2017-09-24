require 'movienga/cashbox'

class CashboxedCinema
  include Movienga::Cashbox
end

describe CashboxedCinema do
  let(:cinema) { described_class.new }
  let(:stranger) { ('a'..'z').to_a.shuffle[0, 8].join }

  describe '#cash' do
    it { expect(cinema.cash).to eq money(0) }
  end

  describe '#take' do
    before { cinema.send(:deposit_cash, 10) }

    context 'when not bank' do
      it { expect { cinema.take(stranger) }.to raise_error RuntimeError }
    end

    context 'when bank' do
      it do
        expect { cinema.take('Bank') }
          .to change(cinema, :cash).from(money(10)).to(money(0))
      end
    end
  end
end
