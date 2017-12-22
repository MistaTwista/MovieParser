require 'ruby-progressbar'

module Movienga
  class CollectionEnumerator
    using ProgressBar::Refinements::Enumerator

    def initialize(collection)
      @collection = collection
    end

    def run(title: 'Caching', &block)
      @collection.each.with_progressbar(
        title: title,
        format: "%t: Processed %c/%C |%b>%i| %p%% %e %a",
        &block
      )
    end
  end
end
