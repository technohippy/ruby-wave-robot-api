# http://code.google.com/intl/ja/apis/wave/extensions/robots/python-tutorial.html
require 'rubygems'
require 'sinatra'
require 'waveapi'

robot = Waveapi::Robot.new(
  'Ruby Tutorial', 
  :base_url => '/sample-robot', 
  :image_url => 'http://ruby-wave-robot.heroku.com/images/icon.png',
  :profile_url => 'http://github.com/technohippy/ruby-wave-robot-api'
)

robot.register_handler(Waveapi::WaveletSelfAddedEvent) do |event, wavelet|
  wavelet.reply("\nHi everybody! I'm a Ruby robot!")
end

robot.register_handler(Waveapi::WaveletParticipantsChangedEvent) do |event, wavelet|
  new_participants = event.participants_added
  new_participants.each do |new_participant|
    wavelet.reply("\nHi : #{new_participant}")
  end
end

robot.start
