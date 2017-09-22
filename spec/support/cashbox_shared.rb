shared_examples 'a cashbox' do
  let(:cinema) { described_class.new('spec/data/movies.txt') }

  describe '#cash' do
    it do
      expect(cinema.cash).to eq 0
    end
  end

  describe '#pay' do
    it do
      expect { cinema.pay(10) }.to change(cinema, :cash).from(0).to(10)
    end
  end
end
