require 'movienga/movies/movie'

describe Movienga::Movie do
  it_behaves_like 'a movie'
  include_context 'movie data'
  let(:movie) { described_class.new(modern_movie) }
  subject { movie }

  describe '#to_s' do
    its(:to_s) { is_expected.to match(/The Shawshank Redemption/) }
  end
end
