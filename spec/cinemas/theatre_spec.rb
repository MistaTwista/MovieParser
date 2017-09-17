require 'cinemas/theatre'
require 'timecop'

describe Theatre do
  include_context 'movie data'
  let(:movie_builder) { MovieBuilder.build_movie(ancient_movie) }
  let(:theatre) { Theatre.new('spec/data/movies_cut.txt') }

  describe '#new' do
    it do
      expect(theatre.movies.class).to eq Array
    end
  end

  describe '#show' do
    context 'when morning' do
      it_behaves_like 'random movie chooser' do
        let(:filter) { { period: :ancient } }
        let(:time) { Time.local(2017, 9, 14, 11, 05).strftime("%H:%M") }
      end
    end

    context 'when day' do
      it_behaves_like 'random movie chooser' do
        let(:filter) { { genre: ['Comedy', 'Adventure'] } }
        let(:time) { Time.local(2017, 9, 14, 14, 05).strftime("%H:%M") }
      end
    end

    context 'when evening' do
      it_behaves_like 'random movie chooser' do
        let(:filter) { { genre: ['Drama', 'Horror'] } }
        let(:time) { Time.local(2017, 9, 14, 19, 05).strftime("%H:%M") }
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
