require 'movie_builder'

shared_context 'movies shared context' do
  let(:movie) { described_class.new(movie_data) }
  let(:movie_builder) { MovieBuilder.build_movie(movie_data) }
end
