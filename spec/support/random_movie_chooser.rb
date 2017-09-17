RSpec.shared_examples 'random movie chooser' do
  it 'selecting good movie' do
    expect(theatre).to receive(:select_from_collection) do |collection|
      expect(collection).to all matches_all(filter)
    end.and_return(movie_builder)

    expect(theatre)
      .to receive(:select_by_time).with(time).and_call_original

    allow(theatre)
      .to receive(:select_from_collection).and_return(movie_builder)

    Timecop.freeze(time) do
      expect { theatre.show(time) }.to output(/ancient movie/).to_stdout
    end
  end
end
