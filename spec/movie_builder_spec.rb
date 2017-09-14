require 'movies_mock'

describe MovieBuilder do
  include_context 'movies shared context'
  subject { movie_builder.class }

  describe '.build_movie' do
    context 'when AncientMovie' do
      let(:movie_data) { MoviesMock::ANCIENT_MOVIE }
      it { is_expected.to eq AncientMovie }
    end

    context 'when ClassicMovie' do
      let(:movie_data) { MoviesMock::CLASSIC_MOVIE }
      it { is_expected.to eq ClassicMovie }
    end

    context 'when ModernMovie' do
      let(:movie_data) { MoviesMock::MODERN_MOVIE }
      it { is_expected.to eq ModernMovie }
    end

    context 'when NewMovie' do
      let(:movie_data) { MoviesMock::NEW_MOVIE }
      it { is_expected.to eq NewMovie }
    end

    context 'when unknown movie age' do
      let(:movie_data) { MoviesMock::UNKNOWN_MOVIE }
      it { expect { movie_builder.class }.to raise_error RuntimeError }
    end
  end
end
