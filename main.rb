$LOAD_PATH << '.'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'hound'

get '/' do
	haml :index
end

get '/stylesheet.css' do
  scss :stylesheet
end

get '/search/:keyword' do |keyword|
	search keyword
end