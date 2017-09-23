shared_examples 'a cashbox' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }
  let(:movie_name) { ('a'..'z').to_a.shuffle[0, 8].join }

  describe '#cash' do
    it { expect(cinema.cash).to eq 0 }
  end

  describe '#take' do
    before { cinema.send(:deposit, 10) }

    context 'when not bank' do
      it do
        expect { cinema.take(movie_name) }.to raise_error RuntimeError
      end
    end

    context 'when bank' do
      it do
        expect { cinema.take('Bank') }.to change(cinema, :cash).from(10).to(0)
      end
    end
  end
end

shared_examples 'a online theatre' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }

  describe '#pay' do
    it do
      expect { cinema.pay(10) }.to change(cinema, :cash).from(0).to(10)
    end
  end
end

shared_examples 'a theatre' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }

  describe '#buy_ticket' do
    context 'when morning' do
      it do
        Timecop.freeze(Time.local(2017, 9, 14, 10, 15)) do
          expect { theatre.buy_ticket('The Terminator') }
            .to output(/bought/).to_stdout
            .and change(theatre, :cash).from(0).to(3)
        end
      end
    end

    context 'when day' do
      it do
        Timecop.freeze(Time.local(2017, 9, 14, 14, 15)) do
          expect { theatre.buy_ticket('The Terminator') }
            .to output(/bought/).to_stdout
            .and change(theatre, :cash).from(0).to(5)
        end
      end
    end

    context 'when evening' do
      it do
        Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
          expect { theatre.buy_ticket('The Terminator') }
            .to output(/bought/).to_stdout
            .and change(theatre, :cash).from(0).to(10)
        end
      end
    end
  end

end
