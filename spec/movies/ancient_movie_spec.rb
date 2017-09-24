require 'movies/ancient_movie'

describe Movienga::AncientMovie do
  it_behaves_like 'a movie'
  include_context 'movie data'
  let(:movie) { described_class.new(ancient_movie) }
  subject { movie }

  describe '#to_s' do
    its(:to_s) { is_expected.to eq 'Casablanca - ancient movie (1942)' }
  end

  describe '#period' do
    its(:period) { is_expected.to eq :ancient }
  end
end
