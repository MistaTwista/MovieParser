require 'movienga/tmdb_parser'

describe Movienga::TMDBParser do
  let(:cache) { double() }
  let(:tmdb_parser) { described_class.new(api_key: '123', cache: cache) }

  describe '#initialize' do
    it do
      expect(Tmdb::Api).to receive(:key).with('123')
      tmdb_parser.language
    end
  end

  describe '#language' do
    it do
      expect(tmdb_parser).to receive(:change_api_language)
      tmdb_parser.language = 'en'
      expect(tmdb_parser.language).to eq 'en'
    end
  end

  describe '#parse' do
    it do
      movie = double()
      expect(movie).to receive(:poster_path).twice.and_return('/file.jpg')

      expect(Tmdb::Find).to receive(:movie)
        .with('tt0100500', external_source: 'imdb_id')
        .and_return([movie])

      expect(cache).to receive(:persist_data)
        .with(id: 'tt0100500', group: 'ru', data: movie)

      expect(tmdb_parser).to receive(:path_to_image).and_return('/cache/file.jpg')

      expect(cache).to receive(:persist_file)
        .with(id: 'tt0100500', group: 'ru', file_url: '/cache/file.jpg')

      tmdb_parser.parse('tt0100500')
    end
  end
end
