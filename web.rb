require 'sinatra'

set :haml, :format => :html5

get '/' do
	haml :index
end

get '/ld26.js' do
	coffee :ld26
end
