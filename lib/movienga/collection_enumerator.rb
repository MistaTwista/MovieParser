require 'ruby-progressbar'

module Movienga
  # Enumerates collection with proc and progressbar
  class CollectionEnumerator
    using ProgressBar::Refinements::Enumerator

    def initialize(collection)
      @collection = collection
    end

    # Execute enumeration
    #
    # @param title [String] Title for progress bar
    # @param block [Proc] Block to use with each element
    def run(title: 'Caching', &block)
      @collection.each.with_progressbar(
        title: title,
        format: "%t: Processed %c/%C |%b>%i| %p%% %e %a",
        &block
      )
    end
  end
end
