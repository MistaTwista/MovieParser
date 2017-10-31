shared_examples 'a movie' do
  include_context 'movie data'

  let(:collection) { double }
  let(:movie) { described_class.new(modern_movie) }
  let(:movie_with_collection) { described_class.new(modern_movie, collection) }
  subject { movie }

  describe '#has_genre' do
    it do
      allow(collection).to receive(:has_genre?).and_return(true)

      expect(movie_with_collection.has_genre?('Drama')).to be_truthy
    end

    it 'raise error if no such genre in collection' do
      allow(collection).to receive(:has_genre?).and_return(false)

      expect { movie_with_collection.has_genre?('Cmedy') }
        .to raise_error RuntimeError
    end
  end

  describe '#title' do
    its(:title) { is_expected.to eq 'The Shawshank Redemption' }
  end

  describe '#year' do
    its(:year) { is_expected.to eq 1994 }
  end

  describe '#country' do
    its(:country) { is_expected.to eq 'USA' }
  end

  describe '#date' do
    it { expect(movie.date.strftime('%d-%m-%Y')).to eq '14-10-1994' }
  end

  describe '#genre' do
    its(:genre) { is_expected.to eq %w[Crime Drama] }
  end

  describe '#length' do
    its(:length) { is_expected.to eq 142 }
  end

  describe '#rate' do
    its(:rate) { is_expected.to eq 9.3 }
  end

  describe '#director' do
    its(:director) { is_expected.to eq 'Frank Darabont' }
  end

  describe '#actors' do
    its(:actors) do
      is_expected.to eq ['Tim Robbins', 'Morgan Freeman', 'Bob Gunton']
    end
  end

  describe '#month' do
    its(:month) { is_expected.to eq 'October' }
  end
end
