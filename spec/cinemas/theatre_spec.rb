require 'movie_builder'
require 'cinemas/theatre'
require 'irb'

describe Theatre do
  let(:theatre) { Theatre.new('spec/data/movies_cut.txt') }

  describe '#new' do
    it do
      expect(theatre.movies.class).to eq Array
    end
  end

  describe '#show' do
    context 'when morning' do
      let(:now) { DateTime.parse('11:05') }

      it do
        expect { theatre.show(now) }.to output(/City Lights/).to_stdout
      end
    end

    context 'when day' do
      let(:now) { DateTime.parse('14:05') }

      it do
        expect { theatre.show(now) }.to output(/City Lights/).to_stdout
      end
    end

    context 'when evening' do
      let(:now) { DateTime.parse('19:05') }

      it do
        expect { theatre.show(now) }.to output(/Alien/).to_stdout
      end
    end
  end

  describe '#when?' do
    context 'never' do
      it do
        expect { theatre.when?('The Terminator') }.to raise_error RuntimeError
      end
    end

    context 'sometime' do
      it do
        expect(theatre.when?('Alien')).to eq %i[evening]
      end
    end
  end
end
