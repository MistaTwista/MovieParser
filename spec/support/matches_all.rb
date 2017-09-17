RSpec::Matchers.define :matches_all do |filter|
  match { |movie| movie.matches_all?(filter) }
end
