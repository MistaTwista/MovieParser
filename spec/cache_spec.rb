require 'movienga/cache'

describe Movienga::Cache do
  let(:cache) { described_class.new }

  describe '#persist' do
    let(:data) { { take: 'this', data: 'and', put: 'to cache' } }

    context 'good path' do
      it do
        expect(File).to receive(:open).with('cache/tt1000/common/data.yml', 'r+')
        expect(cache.persist(id: 'tt1000', data: data))
      end
    end

    context 'bad path' do
      it do
        expect(cache).to receive(:good_path_for?)
          .with('cache/tt1000/common/data.yml').and_return(false)
        expect { cache.persist(id: 'tt1000', data: data) }
          .to raise_error RuntimeError
      end
    end
  end

  describe '#get' do
    context 'file not found' do
      it do
        expect(File).to receive(:exist?)
          .with('cache/tt1000/common/data.yml').and_return(false)
        expect { cache.get('tt1000') }.to raise_error RuntimeError
      end
    end

    context 'data loaded' do
      it do
        expect(YAML).to receive(:load_file).with('cache/tt1000/common/data.yml')
        expect(File).to receive(:exist?).and_return(true)
        cache.get('tt1000')
      end
    end
  end
end

describe Movienga::FileCache do
  let(:cache) { described_class.new(file: 'poster.jpg') }

  describe '#persist' do
    context 'good path' do
      before do
        cache.clear('cache/tt1000/rus/poster.jpg')
      end

      it do
        expect(cache).to receive(:download_file)
          .with('/some.png', 'cache/tt1000/common/poster.jpg')
        cache.persist(id: 'tt1000', file_url: '/some.png')
      end
    end

    context 'bad path' do
      it do
        expect(cache).to receive(:good_path_for?)
          .with('cache/tt1000/common/poster.jpg').and_return(false)
        expect {
          cache.persist(id: 'tt1000', file_url: '/some.jpg')
        }.to raise_error RuntimeError
      end
    end

    context 'file exists' do
      it do
        expect(File).to receive(:exist?)
          .with('cache/tt1000/common/poster.jpg').and_return(true)
        expect {
          cache.persist(id: 'tt1000', file_url: '/some.gif')
        }.to raise_error RuntimeError
      end
    end
  end

  describe '#get' do
    it do
      expect(cache.get('tt1000')).to eq 'cache/tt1000/common/poster.jpg'
    end
  end
end
