RSpec.shared_examples 'choose movie by time' do |requested_time, filter|
  describe 'random chooser' do
    let(:time) { DateTime.parse("#{requested_time} +0300") }
    let(:ftime) { time.strftime("%H:%M") }

    it 'selecting good movie' do
      expect(theatre_block)
        .to receive(:filter).with(filter).and_return [current_movie]

      Timecop.freeze(time) do
        expect { theatre_block.show(ftime, :green) }
          .to output(/#{ftime}/).to_stdout
      end
    end
  end
end
