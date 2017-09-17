require 'cinemas/theatre'

describe Theatre do
  let(:theatre) { Theatre.new('spec/data/movies_cut.txt') }

  describe '#new' do
    it do
      expect(theatre.movies.class).to eq Array
    end
  end

  describe '#show' do
    context 'when morning' do
      it do
        expect { theatre.show('11:05') }.to output(/Ancient Movie/).to_stdout
      end
    end

    context 'when day' do
      it do
        expect { theatre.show('14:05') }.to output(/Comedy Movie/).to_stdout
      end
    end

    context 'when evening' do
      it do
        expect { theatre.show('19:05') }.to output(/Alien/).to_stdout
      end
    end

    context 'when closed' do
      it do
        expect { theatre.show('6:05') }
          .to raise_error(RuntimeError, /closed/)
      end
    end

    context 'show any' do
      it do
        expect { theatre.show }.to output(/Now showing/).to_stdout
      end
    end
  end

  describe '#when?' do
    context 'never' do
      it do
        expect(theatre.when?('The Terminator'))
          .to eq [{"The Terminator"=>[:never]}]
      end
    end

    context 'sometime' do
      it do
        expect(theatre.when?('Alien')).to eq [{"Alien"=>[:evening]}]
      end
    end

    context 'many movies matched' do
      it do
        expect(theatre.when?(/[A-Z]/))
          .to eq [
            {"Alien"=>[:evening]},
            {"Comedy Movie"=>[:day]},
            {"Ancient Movie"=>[:morning]},
            {"The Terminator"=>[:never]}
          ]
      end
    end
  end
end
