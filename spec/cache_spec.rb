require 'movienga/cache'

describe Movienga::Cache do
  let(:cache) { described_class.new }

  before :each { cache.clear }

  describe '#persist' do
    let(:data) { { take: 'this', data: 'and', put: 'to cache' } }

    context 'when cache works' do
      it do
        cache.persist('tt1000', data)
        expect(cache.get('tt1000')).to eq data
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
  end
end

describe Movienga::FileCache do
  let(:cache) { described_class.new(file: 'poster.jpg') }

  before :each { cache.clear }

  describe '#persist' do
    context 'good path' do
      it do
        expect(cache).to receive(:download_file)
          .with('/some.png', 'cache/tt1000/common/poster.jpg')
        cache.persist('tt1000', file_url: '/some.png')
      end
    end

    context 'file exists' do
      it do
        expect(File).to receive(:exist?)
          .with('cache/tt1000/common/poster.jpg').and_return(true)
        expect {
          cache.persist('tt1000', file_url: '/some.gif')
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
