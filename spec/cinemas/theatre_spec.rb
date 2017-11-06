require 'movienga/cinemas/theatre'
require 'timecop'

describe Movienga::Theatre do
  include_context 'movie data'

  let(:current_movie) { Movienga::MovieBuilder.build_movie(ancient_movie) }
  let(:theatre) { described_class.new('spec/data/movies_cut.txt') }

  let(:theatre_block) do
    described_class.new('spec/data/movies.txt') do
      hall :red, title: 'Red hall', places: 100
      hall :green, title: 'Green hall', places: 150

      period '09:00'..'12:00' do
        description 'Morning movies'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red
      end

      period '09:00'..'12:00' do
        description 'Modern comedies'
        filters genre: 'Comedy', year: 1990..2015
        price 10
        hall :green
      end

      period '14:00'..'16:30' do
        description 'Modern comedies'
        filters genre: 'Action', year: 2005..Time.now.year
        price 10
        hall :green
      end

      period '17:00'..'20:00' do
        description 'Modern comedies'
        filters genre: 'Action', year: 1990..Time.now.year
        price 10
        hall :green
      end
    end
  end

  let(:theatre_bad_hall_block) do
    described_class.new('spec/data/movies.txt') do
      hall :red, title: 'Red hall', places: 100

      period '09:00'..'11:00' do
        description 'Morning movies'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red
      end

      period '10:30'..'11:30' do
        description 'Not available'
        filters genre: 'Action'
        price 1
        hall :black
      end
    end
  end

  let(:theatre_bad_period_block) do
    described_class.new('spec/data/movies.txt') do
      hall :red, title: 'Red hall', places: 100

      period '09:00'..'11:00' do
        description 'Morning movies'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red
      end

      period '09:30'..'11:30' do
        description 'Not available'
        filters genre: 'Action'
        price 1
        hall :red
      end
    end
  end

  describe '#new' do
    it { expect(theatre.movies.class).to eq Array }
    it { expect(theatre_block.movies.class).to eq Array }

    it do
      expect { theatre_bad_period_block }
        .to raise_error(RuntimeError, /is not available/)
    end

    it do
      expect { theatre_bad_hall_block }
        .to raise_error(RuntimeError, /No such hall name/)
    end
  end

  describe '#get_hall' do
    it do
      expect(theatre_block.get_hall(:red).class).to eq Movienga::Hall
    end
  end

  describe '#show' do
    context 'when morning' do
      it_behaves_like 'choose movie by time',
        '11:05', { genre: 'Comedy', year: 1990..2015 }
    end

    context 'when day' do
      it_behaves_like 'choose movie by time',
        '14:05', { genre: 'Action', year: 2005..Time.now.year }
    end

    context 'when evening' do
      it_behaves_like 'choose movie by time',
        '19:05', { genre: 'Action', year: 1990..Time.now.year }
    end

    context 'when no movies' do
      it do
        expect { theatre.show('6:05') }
          .to raise_error(RuntimeError, /No movies at/)
      end
    end

    context 'when nothing to show' do
      it do
        allow(theatre).to receive(:filter_by_time).and_return([])
        expect { theatre.show('6:05') }.to raise_error Movienga::NothingToShow
      end
    end

    context 'show any' do
      it do
        Timecop.freeze(Time.local(2017, 9, 14, 18, 15)) do
          expect { theatre_block.show }.to output(/Now showing/).to_stdout
        end
      end
    end

    context 'new show' do
      it do
        expect { theatre_block.show('10:00') }
          .to raise_error(RuntimeError, /enter hall name/)
      end

      it do
        expect { theatre_block.show('10:00', :green) }
          .to output(/Now showing/).to_stdout
      end
    end
  end

  describe '#when?' do
    context 'never' do
      it do
        expect(theatre.when?('The Terminator'))
          .to eq({"The Terminator" => []})
      end
    end

    context 'sometime' do
      it { expect(theatre.when?('Alien')).to eq({ "Alien" => [:evening] }) }
    end

    context 'many movies matched' do
      it do
        expect(theatre.when?(/[A-Z]/))
          .to eq({
              "Alien" => [:evening],
              "Comedy Movie" => [:day],
              "Ancient Movie" => [:morning],
              "The Terminator" => []
            })
      end
    end
  end

  describe '#buy_ticket' do
    context 'when morning movie' do
      it do
        expect { theatre.buy_ticket('Ancient Movie') }
          .to output(/bought/).to_stdout
          .and change(theatre, :cash).from(money(0)).to(money(3))
      end
    end

    context 'when day movie' do
      it do
        expect { theatre.buy_ticket('Comedy Movie') }
          .to output(/bought/).to_stdout
          .and change(theatre, :cash).from(money(0)).to(money(5))
      end
    end

    context 'when evening movie' do
      it do
        expect { theatre.buy_ticket('Alien') }
          .to output(/bought/).to_stdout
          .and change(theatre, :cash).from(money(0)).to(money(10))
      end
    end

    context 'when not showing' do
      it do
        expect { theatre.buy_ticket('The Terminator') }
          .to raise_error Movienga::NothingToShow
      end
    end
  end

  describe '#cash' do
    let(:other_theatre) { described_class.new('spec/data/movies_cut.txt') }

    it do
      expect { other_theatre.buy_ticket('Alien') }
        .to output(/bought/).to_stdout
        .and change(other_theatre, :cash).from(money(0)).to(money(10))

      expect(theatre.cash).to eq money(0)
    end
  end
end
