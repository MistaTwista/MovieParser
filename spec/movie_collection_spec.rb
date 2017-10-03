require 'movienga/movie_collection'
require 'movienga/movies/ancient_movie'

RSpec.describe Movienga::MovieCollection do
  let(:no_file_collection) {  described_class.new('bad/path/file.txt') }
  let(:collection) {  described_class.new('spec/data/movies.txt') }
  subject { collection }

  describe 'enumerable' do
    its(:each) { is_expected.to be_instance_of Enumerator }
    its(:map) { is_expected.to be_instance_of Enumerator }
    its(:select) { is_expected.to be_instance_of Enumerator }
    its(:reject) { is_expected.to be_instance_of Enumerator }
  end

  describe 'parse file' do
    context 'when ok' do
      it { expect(collection.movies.class).to be Array }
    end

    context 'when no such file' do
      it do
        expect { no_file_collection }.to raise_error Errno::ENOENT
      end
    end
  end

  describe 'collection type' do
    context 'when default Movie' do
      it { expect(collection.movies.first.class).to be Movienga::Movie }
    end

    context 'when custom type' do
      let(:collection) do
        described_class.new('spec/data/movies.txt', movie_class: Movienga::AncientMovie)
      end

      it { expect(collection.movies.first.class).to be Movienga::AncientMovie }
    end
  end

  describe '#all' do
    it { expect(collection.all.count).to eq 250 }
  end

  describe '#sort_by' do
    it do
      expect(collection.sort_by(:title).last.title).to eq 'Yojimbo'
      expect(collection.sort_by(:year).first.title).to eq 'The Kid'
      expect(collection.sort_by(:country).last.title).to eq 'Das Boot'
      expect(collection.sort_by(:date).last.title).to eq 'Inside Out'
      expect(collection.sort_by(:genre).first.title).to eq 'Kill Bill: Vol. 1'
      expect(collection.sort_by(:length).last.title).to eq 'Gone with the Wind'
      expect(collection.sort_by(:rate).first.title).to eq 'Beauty and the Beast'
      expect(collection.sort_by(:director).last.title).to eq 'Departures'
      expect(collection.sort_by(:actors).first.title).to eq '3 Idiots'
      expect{ collection.sort_by(:unknown) }.to raise_error NoMethodError
    end
  end

  describe '#filter' do
    it do
      expect(collection.filter(director: 'Nolan'))
        .to all have_attributes(director: 'Christopher Nolan')
      expect(collection.filter(actors: 'Brad Pitt'))
        .to all have_attributes(actors: array_including('Brad Pitt'))
      expect(collection.filter(genre: 'Comedy'))
        .to all have_attributes(genre: array_including('Comedy'))
      expect(collection.filter(year: 1957))
        .to all have_attributes(year: 1957)
      expect(collection.filter(month: 'January'))
        .to all have_attributes(month: 'January')
      expect(collection.filter(country: 'USA'))
        .to all have_attributes(country: 'USA')
      expect(collection.filter(actors: 'Arnold Schwarzenegger', year: 1991))
        .to all have_attributes(actors: array_including('Arnold Schwarzenegger'), year: 1991)
      expect(collection.filter(title: /terminator/i))
        .to all have_attributes(title: /terminator/i)
      expect(collection.filter(year: 2001..2005))
        .to all have_attributes(year: 2001..2005)
    end
  end

  describe '#stats' do
    it do
      expect(collection.stats(:director)['Christopher Nolan']).to eq 7
      expect(collection.stats(:actors)['Heath Ledger']).to eq 1
      expect(collection.stats(:year)[1984]).to eq 4
      expect(collection.stats(:month)['July']).to eq 18
      expect(collection.stats(:genre)['Sci-Fi']).to eq 23
      expect(collection.stats(:country)['France']).to eq 10
    end
  end

  describe '#has_genre?' do
    context 'when truthy' do
      it do
        expect(collection.has_genre?('Comedy')).to be_truthy
      end
    end

    context 'when falsy' do
      it do
        expect(collection.has_genre?('Cmdy')).to be_falsy
      end
    end
  end
end
