lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movienga/version'

Gem::Specification.new do |spec|
  spec.name          = 'movienga'
  spec.version       = Movienga::VERSION
  spec.email         = 'ctajikep@gmail.com'
  spec.homepage      = 'https://github.com/MistaTwista/MovieParser'
  spec.authors       = ['Maxim Kernozhitskiy']

  spec.summary       = %q{Learning and experimenting gem using TMDB & IMDB}
  spec.description   = %q{Gem parse csv file, download additional data from API}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
