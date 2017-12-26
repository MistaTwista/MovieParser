# Movienga

This is fun for playing and learning gem that parses CSV file, uses TMDB & IMDB data to show some information about movies.

See data examples in ```spec/data```

## Installation

You need to clone this repo to use it as a gem. Or you can use it for any purposes you want! Just:

```ruby
require 'movienga'

netflix = Movienga::Netflix.new('data.txt')
netflix.show genre: 'Comedy', actors: 'Brad Pitt'
```

## Usage

### Download additional data

You can download data from TMDB and IMDB by

```bin/fetch_and_cache```

### One more thing

```bin/netflix --pay 10 --show genre:Comedy --data 'data.txt'```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
