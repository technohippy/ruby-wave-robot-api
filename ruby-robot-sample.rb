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

robot = Waveapi::Robot.new(
  'Ruby Robot', 
  :base_url => '/sample-robot', 
  :image_url => 'http://ruby-wave-robot.heroku.com/images/icon.png',
  :profile_url => 'http://ruby-wave-robot-api.heroku.com'
)
robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
  wavelet.reply("Hi, I'm Ruby Robot.")
end

robot.start
