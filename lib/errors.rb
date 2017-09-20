class NothingToShow < StandardError
  def initialize(message = 'Movie not found')
    super message
  end
end
