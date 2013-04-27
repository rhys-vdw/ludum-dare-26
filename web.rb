require 'sinatra'
require 'haml'
require 'sass'

get '/stylesheets/style.css' do
  sass :style
end


get '/' do
	haml :index
end

get '/ld26.js' do
	coffee :ld26
end
