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

get '/plurks/:pid' do |pid|
	File.read(File.join('plurks',pid + '.html'))
end

get '/static/*.css', :provides=>:css do |path|
	content_type 'text/css'
	File.read(File.join('static',path + ".css"))
end

get '/static/*' do |path|
	File.read(File.join('static',path))
end