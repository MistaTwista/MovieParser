require 'movies/new_movie'

describe Movienga::NewMovie do
  it_behaves_like 'a movie'
  include_context 'movie data'
  let(:movie) { described_class.new(new_movie) }
  subject { movie }

  describe '#to_s' do
    its(:to_s) { is_expected.to match(/Dark Knight/) }
  end

  describe '#period' do
    its(:period) { is_expected.to eq :new }
  end
end
