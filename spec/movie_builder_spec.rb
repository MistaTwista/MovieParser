require 'movie_builder'
require 'movies_mock'

describe MovieBuilder do
  let(:builder) { MovieBuilder.build_movie(mock) }

  describe '.build_movie' do
    context 'when AncientMovie' do
      let(:mock) { MoviesMock::ANCIENT_MOVIE }

      it do
        expect(builder.class).to eq AncientMovie
      end
    end

    context 'when ClassicMovie' do
      let(:mock) { MoviesMock::CLASSIC_MOVIE }

      it do
        expect(builder.class).to eq ClassicMovie
      end
    end

    context 'when ModernMovie' do
      let(:mock) { MoviesMock::MODERN_MOVIE }

      it do
        expect(builder.class).to eq ModernMovie
      end
    end

    context 'when NewMovie' do
      let(:mock) { MoviesMock::NEW_MOVIE }

      it do
        expect(builder.class).to eq NewMovie
      end
    end

    context 'when unknown movie age' do
      let(:mock) { MoviesMock::UNKNOWN_MOVIE }

      it do
        expect { builder.class }.to raise_error RuntimeError
      end
    end
  end
end
