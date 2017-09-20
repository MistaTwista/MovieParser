require 'movies/classic_movie'

describe ClassicMovie do
  it_behaves_like 'a movie'
  include_context 'movie data'
  let(:collection) { double }
  let(:movie) { described_class.new(classic_movie, collection) }
  let(:virus) { build(:movie, title: 'Virus') }
  let(:alien) { build(:movie, title: 'Alien') }
  subject { movie }

  describe '#to_s' do
    its(:to_s) do
      expect(collection)
        .to receive(:filter).and_return([virus, alien])

      is_expected.to match(/Virus, Alien/)
    end
  end

  describe '#period' do
    its(:period) { is_expected.to eq :classic }
  end
end
