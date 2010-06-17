=begin
Robot ID: ruby-wave-robot@googlewaverobots.com
Robot Base URL: http://ruby-wave-robot.heroku.com/sample-robot
Consumer Key: 728446359664
Consumer Secret: I8W2DZs/XGV8jHR0btTWSsww
=end
require 'rubygems'
require 'sinatra'
require 'erb'

VERSION = 2

get '/' do
  'Ruby Wave Robot'
end

=begin
get '/sample-robot/_wave/verify_token' do
  'abcdefghijklmnopqrstuvwxyz'
end
=end

get '/sample-robot/_wave/robot/profile' do
  content_type :json
  erb :profile
end

get '/sample-robot/_wave/capabilities.xml' do
  content_type :xml
  erb :capabilities
end

post '/sample-robot/_wave/robot/jsonrpc' do
  content_type :json
  wave_id = $1 if request.body.read =~ /"waveId":"(.*?)"/
  erb :jsonrpc, {}, :wave_id => wave_id
end
