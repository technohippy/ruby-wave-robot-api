=begin
Robot ID: ruby-wave-robot-api@googlewaverobots.com
Robot Base URL: http://ruby-wave-robot-api.heroku.com/sample-robot
Consumer Key: 175416260065
Consumer Secret: q1ugdhhkNZHGKyJHG212apzS
=end
require 'rubygems'
require 'sinatra'
require 'erb'
require 'waveapi'

VERSION = 2

get '/' do
  'Ruby Wave Robot'
end

get '/sample-robot/_wave/verify_token' do
  'AOijR2faVHnuVwuPc7Tek3VG1yy7RDdK3N0a9HjMaQh' \
  '0mNLf1xluUba4s4829ruM4SNgOfaAxuXodk5gFzNxHS' \
  'mkV_T9hG3EINYkpegBjNk5YJXcGk8Gj0JqcbcfHhLfp' \
  'nJvawVXEG-x_hevAWUfkcLhxJp-KuKi-Q=='
end

get '/sample-robot/_wave/robot/profile' do
  content_type :json
  erb :profile
end

get '/sample-robot/_wave/capabilities.xml' do
  content_type :xml
  erb :capabilities
end

post '/sample-robot/_wave/robot/jsonrpc' do
  body = request.body.read
  robot = Waveapi::Robot.new('Ruby Robot', :image_url => '', :profile_url => '')
  operation_bundle = robot.handle(body)

  content_type :json
  wave_id = $1 if body =~ /"waveId":"(.*?)"/
  erb :jsonrpc, {}, :wave_id => wave_id
end
