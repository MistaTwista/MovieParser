require 'movienga/cache'

describe Movienga::Cache do
  let(:cache) { described_class.new }

  describe '#persist_data' do
    context 'good path' do
      it do
        data = { take: 'this', data: 'and', put: 'to cache' }
        expect(File).to receive(:new)
        expect(File).to receive(:open).with('cache/tt1000/rus/data.yml', 'r+')
        expect(cache.persist_data(id: 'tt1000', group: 'rus', data: data))
      end
    end

    context 'bad path' do
      it do
        data = { take: 'this', data: 'and', put: 'to cache' }
        expect(cache).to receive(:good_path?)
          .with('cache/tt1000/rus').and_return(false)
        expect { cache.persist_data(id: 'tt1000', group: 'rus', data: data) }
          .to raise_error RuntimeError
      end
    end
  end

  describe '#persist_file' do
    context 'good path' do
      it do
        expect(cache).to receive(:download_file)
          .with('/some.png', 'cache/tt1000/rus')
        cache.persist_file(id: 'tt1000', group: 'rus', file_url: '/some.png')
      end
    end

    context 'bad path' do
      it do
        expect(cache).to receive(:good_path?)
          .with('cache/tt1000/rus').and_return(false)
        expect {
          cache.persist_file(id: 'tt1000', group: 'rus', file_url: '/some.jpg')
        }.to raise_error RuntimeError
      end
    end

    context 'file exists' do
      it do
        expect(File).to receive(:exists?)
          .with('cache/tt1000/rus/poster.jpg').and_return(true)
        expect {
          cache.persist_file(id: 'tt1000', group: 'rus', file_url: '/some.gif')
        }.to raise_error RuntimeError
      end
    end
  end

  describe '#get_data' do
    context 'file not found' do
      it do
        expect(File).to receive(:exists?)
          .with('cache/tt1000/rus/data.yml').and_return(false)
        expect {
          cache.get_data(id: 'tt1000', group: 'rus')
        }.to raise_error RuntimeError
      end
    end

    context 'data loaded' do
      it do
        expect(YAML).to receive(:load_file).with('cache/tt1000/rus/data.yml')
        expect(File).to receive(:exists?).and_return(true)
        cache.get_data(id: 'tt1000', group: 'rus')
      end
    end
  end

  describe '#get_file_path' do
    it do
      expect(cache.get_file_path(id: 'tt1000', group: 'en'))
        .to eq 'cache/tt1000/en/poster.jpg'
    end
  end
end
