=begin
Robot ID: ruby-wave-robot-api@googlewaverobots.com
Robot Base URL: http://ruby-wave-robot-api.heroku.com/sample-robot
Consumer Key: 175416260065
Consumer Secret: q1ugdhhkNZHGKyJHG212apzS
=end
require 'rubygems'
require 'sinatra'
require 'waveapi'

robot = Waveapi::Robot.new(
  'Ruby Robot', 
  :base_url => '/sample-robot', 
  :image_url => 'http://ruby-wave-robot.heroku.com/images/icon.png',
  :profile_url => 'http://ruby-wave-robot-api.heroku.com'
)

# http://code.google.com/intl/ja/apis/wave/extensions/robots/python-tutorial.html
robot.register_handler(Waveapi::WaveletSelfAddedEvent) do |event, wavelet|
  wavelet.reply("\nHi everybody! I'm a Ruby robot!")
end

robot.register_handler(Waveapi::WaveletParticipantsChangedEvent) do |event, wavelet|
  new_participants = event.participants_added
  new_participants.each do |new_participant|
    wavelet.reply("\nHi : #{new_participant}")
  end
end

# http://code.google.com/intl/ja/apis/wave/extensions/robots/python-walkthrough.html
robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
  blip = event.blip
  wavelet.title = 'A wavelet title'
  blip.append(Waveapi::Image.new(
    :url => 'http://www.google.com/logos/clickortreat1.gif',
    :width => 320, :height => 118))
=begin
  wavelet.proxy_for('douwe').reply().append('hi from douwe')
  inline_blip = blip.insert_inline_blip(5)
  inline_blip.append('hello again!')
  new_wave = robot.new_wave(wavelet.domain, wavelet.participants, :message => wavelet.to_s)
  new_wave.root_blip.append('A new day and a new wave')
  new_wave.root_blip.append_markup('<p>Some stuff!</p><p>Not the <b>beautiful</b></p>') 
  new_wave.submit_with(wavelet)
=end
end

robot.start
