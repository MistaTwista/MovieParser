require 'cinemas/theatre'
require 'timecop'

describe Theatre do
  include_context 'movie data'
  let(:movie_builder) { MovieBuilder.build_movie(ancient_movie) }
  let(:theatre) { Theatre.new('spec/data/movies_cut.txt') }

  describe '#new' do
    it { expect(theatre.movies.class).to eq Array }
  end

  describe '#show' do
    context 'when morning' do
      it_behaves_like 'choose movie by time', '11:05', period: :ancient
    end

    context 'when day' do
      it_behaves_like 'choose movie by time',
        '14:05', genre: ['Comedy', 'Adventure']
    end

    context 'when evening' do
      it_behaves_like 'choose movie by time',
        '19:05', genre: ['Drama', 'Horror']
    end

    context 'when closed' do
      it do
        expect { theatre.show('6:05') }
          .to raise_error(RuntimeError, /closed/)
      end
    end

    context 'when nothing to show' do
      it do
        allow(theatre).to receive(:filter_by_time).and_return([])
        expect { theatre.show('6:05') }.to raise_error NothingToShow
      end
    end

    context 'show any' do
      it do
        Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
          expect { theatre.show }.to output(/Now showing/).to_stdout
        end
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
      it { expect(theatre.when?('Alien')).to eq [{"Alien"=>[:evening]}] }
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
