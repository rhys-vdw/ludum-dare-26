require 'sinatra'
require 'haml'
require 'compass'
require 'sass'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end

get '/stylesheets/style.css' do
  sass :style
end


get '/' do
	haml :index
end

get '/ld26.js' do
	coffee :ld26
end
