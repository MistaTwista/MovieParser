shared_examples 'a movie' do
  include_context 'movie data'

  let(:collection) { double }
  let(:movie) { described_class.new(modern_movie) }
  let(:movie_with_collection) { described_class.new(modern_movie, collection) }

  describe '#has_genre' do
    it do
      expect(movie.has_genre?('Drama')).to be_truthy
    end

    it 'raise error if no such genre in collection' do
      allow(collection).to receive(:has_genre?).and_return(false)

      expect { movie_with_collection.has_genre?('Cmedy') }
        .to raise_error RuntimeError
    end
  end

  describe '#title' do
    it { expect(movie.title).to eq 'The Shawshank Redemption' }
  end

  describe '#year' do
    it { expect(movie.year).to eq 1994 }
  end

  describe '#country' do
    it { expect(movie.country).to eq 'USA' }
  end

  describe '#date' do
    it { expect(movie.date.strftime('%d-%m-%Y')).to eq '14-10-1994' }
  end

  describe '#genre' do
    it { expect(movie.genre).to eq %w[Crime Drama] }
  end

  describe '#length' do
    it { expect(movie.length).to eq 142 }
  end

  describe '#rate' do
    it { expect(movie.rate).to eq 9.3 }
  end

  describe '#director' do
    it { expect(movie.director).to eq 'Frank Darabont' }
  end

  describe '#actors' do
    it do
      expect(movie.actors).to eq ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton']
    end
  end

  describe '#month' do
    it { expect(movie.month).to eq 'October' }
  end
end
