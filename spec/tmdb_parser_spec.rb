require 'movienga/tmdb_parser'

describe Movienga::TMDBParser do
  let(:cache) { double() }
  let(:tmdb_parser) do
    described_class.new(api_key: '123', poster_cache: cache, data_cache: cache)
  end

  describe '#initialize' do
    it do
      expect(Tmdb::Api).to receive(:key).with('123')
      tmdb_parser.language
    end
  end

  describe '#parse' do
    let(:movie) { double() }

    it do
      expect(movie).to receive(:poster_path).twice.and_return('/file.jpg')

      expect(Tmdb::Find).to receive(:movie)
        .with('t1000', external_source: 'imdb_id')
        .and_return([movie])

      expect(cache).to receive(:persist).with(id: 't1000', data: movie)

      expect(tmdb_parser).to receive(:path_to_image).and_return('/cache/file.jpg')

      expect(cache).to receive(:persist)
        .with(id: 't1000', file_url: '/cache/file.jpg')

      tmdb_parser.parse('t1000')
    end
  end
end
