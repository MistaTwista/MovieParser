require_relative 'lib/movienga/cinemas/netflix'

class MovieDecorator < SimpleDelegator
  def initialize(movie)
    @movie = movie
    super
  end

  def link
    self.url.split('/')[4]
  end
end

class WebApp
  def options
    {
      title: 'Netflix TOP 250',
      decorator: MovieDecorator
    }
  end

  def call(env)
    req = Rack::Request.new(env)
    case req.path
    when '/'
      [200, {'Content-Type' => "text/html"}, [template('netflix').render(data_source, options)]]
    when /\A\/tt\d*\z/
      filter = ->(movie) { movie.url.include?(req.path) }
      view = template('movie').render(Object.new, { movie: data_source.filter(&filter).first })
      [200, {'Content-Type' => "text/html"}, [view]]
    else
      [404, {'Content-Type' => "text/html"}, ['Not found']]
    end
  end

  def data_source(filename = './spec/data/movies.txt')
    unless File.readable?(filename)
      raise "#{filename} not found or can't be read"
    end

    @data_source ||= Movienga::Netflix.new(filename)
  end

  def template(name)
    file = File.join(WebApp.root, 'app', 'views', "#{name}.haml")
    Haml::Engine.new(File.read(file))
  end

  def self.root
    File.dirname(__FILE__)
  end
end

# require 'yaml'
# ROUTES = YAML.load(File.read(File.join(File.dirname(__FILE__), "app", "routes.yml"))) # 1
