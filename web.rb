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

get '/bullet.js' do
  coffee :bullet
end

get '/tank.js' do
  coffee :tank
end

get '/startup.js' do
	coffee :startup
end

get '/terrain.js' do
	coffee :terrain
end
