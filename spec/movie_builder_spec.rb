require 'movie_builder'

describe MovieBuilder do
  subject { movie_builder.class }
  include_context 'movie data'
  let(:movie_builder) { MovieBuilder.build_movie(movie_hash) }

  describe '.build_movie' do
    context 'when AncientMovie' do
      let(:movie_hash) { ancient_movie }
      it { is_expected.to eq AncientMovie }
    end

    context 'when ClassicMovie' do
      let(:movie_hash) { classic_movie }
      it { is_expected.to eq ClassicMovie }
    end

    context 'when ModernMovie' do
      let(:movie_hash) { modern_movie }
      it { is_expected.to eq ModernMovie }
    end

    context 'when NewMovie' do
      let(:movie_hash) { new_movie }
      it { is_expected.to eq NewMovie }
    end

    context 'when unknown movie age' do
      let(:movie_hash) { unknown_movie }
      it { expect { movie_builder.class }.to raise_error RuntimeError }
    end
  end
end
