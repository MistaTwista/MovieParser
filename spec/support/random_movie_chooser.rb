RSpec.shared_examples 'choose movie by time' do |requested_time, filter|
  describe 'random chooser' do
    let(:time) { DateTime.parse("#{requested_time} +0300") }
    let(:ftime) { time.strftime("%H:%M") }

    it 'selecting good movie' do
      expect(theatre)
        .to receive(:filter).with(filter).and_return([movie_builder])

      Timecop.freeze(time) do
        expect { theatre.show(ftime) }.to output(/#{ftime}/).to_stdout
      end
    end
  end
end
