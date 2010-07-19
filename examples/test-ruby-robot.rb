require 'rubygems'
require 'sinatra'
require 'waveapi'

robot = Waveapi::Robot.new(
  'Ruby Robot', 
  :base_url => '/sample-robot', 
  :image_url => 'http://ruby-wave-robot.heroku.com/images/icon.png',
  :profile_url => 'http://ruby-wave-robot-api.heroku.com'
)

robot.register_handler(Waveapi::WaveletSelfAddedEvent) do |event, wavelet|
  blip = event.blip
  wavelet.title = 'A wavelet title'
  blip.append(Waveapi::Image.new('http://www.google.com/logos/clickortreat1.gif', 320, 118))
  wavelet.proxy_for('douwe').reply().append('hi from douwe')
  inline_blip = blip.insert_inline_blip(5)
  inline_blip.append('hello again!')
  new_wave = robot.new_wave(wavelet.domain, wavelet.participants, wavelet.to_s)
  new_wave.root_blip.append('A new day and a new wave')
  new_wave.root_blip.append_markup('<p>Some stuff!</p><p>Not the <b>beautiful</b></p>') 
  new_wave.submit_with(wavelet)
end

robot.start
