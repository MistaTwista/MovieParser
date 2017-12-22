require_relative 'lib/movienga/cinemas/netflix'

class WebApp
  def options
    {
      title: 'Netflix TOP 250'
    }
  end

  def call(env)
    req = Rack::Request.new(env)
    case req.path
    when '/'
      [
        200, {'Content-Type' => "text/html"},
        [template('netflix').render(data_source, options)]
      ]
    when /\A\/(ru|en)\/tt\d*\z/
      _, language, imdb_id = req.path.split('/')
      next_lang = language == 'en' ? 'ru' : 'en'

      filter = ->(movie) { movie.url.include?(imdb_id) }
      view = template('movie').render(data_source, {
        movie: data_source.filter(&filter).first,
        language: language,
        switch_lang_path: "/#{next_lang}/#{imdb_id}"
      })
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
