=begin
Robot ID: ruby-wave-robot-api@googlewaverobots.com
Robot Base URL: http://ruby-wave-robot-api.heroku.com/sample-robot
Consumer Key: 175416260065
Consumer Secret: q1ugdhhkNZHGKyJHG212apzS
=end
require 'waveapi'

robot = Waveapi::Robot.new(
  'Ruby Robot', 
  :base_url => '/sample-robot', 
  :image_url => 'http://ruby-wave-robot.heroku.com/images/icon.png',
  :profile_url => 'http://ruby-wave-robot-api.heroku.com'
)

robot.register_handler(Waveapi::WaveletSelfAddedEvent) do |event, wavelet|
  wavelet.reply("\nHi everybody! I'm a Ruby robot!")
end

robot.register_handler(Waveapi::WaveletParticipantsChangedEvent) do |event, wavelet|
  puts "event: #{event}"
  new_participants = event.participants_added
  new_participants.each do |new_participant|
    wavelet.reply("\nHi : #{new_participant}")
  end
end

robot.start
