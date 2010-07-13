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
  #wavelet.reply("\nHi everybody! I'm a Ruby robot!")
end

robot.register_handler(Waveapi::WaveletParticipantsChangedEvent) do |event, wavelet|
  new_participants = event.participants_added
  new_participants.each do |new_participant|
    #wavelet.reply("\nHi : #{new_participant}")
  end
end

# http://code.google.com/intl/ja/apis/wave/extensions/robots/python-walkthrough.html
robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
  blip = event.blip
  #wavelet.title = 'A wavelet title'
  #blip.append('hello')
  #blip.append(Waveapi::Image.new('http://www.google.com/logos/clickortreat1.gif', 320, 118))
=begin
  inline_blip = blip.insert_inline_blip(5)
  inline_blip.append('hello again!')
  new_wave = robot.new_wave(wavelet.domain, wavelet.participants, :message => wavelet.to_s)
  new_wave.root_blip.append('A new day and a new wave')
  new_wave.root_blip.append_markup('<p>Some stuff!</p><p>Not the <b>beautiful</b></p>') 
  new_wave.submit_with(wavelet)
=end
  wavelet.proxy_for('douwe').reply().append('hi from douwe')
=begin
[
  {
    "params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, 
    "method": "robot.notifyCapabilitiesHash", 
    "id": "0"
  }, 
  {
    "params": {
      "waveletId": "wavesandbox.com!conv+root", 
      "waveId": "wavesandbox.com!w+fZPSm_lQA", 
      "participantId": "ruby-teacher.on-wave+douwe@appspot.com"
    }, 
    "method": "wavelet.participant.add", 
    "id": "op1"
  }, 
  {
    "params": {
      "waveletId": "wavesandbox.com!conv+root", 
      "waveId": "wavesandbox.com!w+fZPSm_lQA", 
      "blipData": {
        "waveletId": "wavesandbox.com!conv+root", 
        "blipId": "TBD_wavesandbox.com!conv+root_0x4f8595d846f3fa72", 
        "waveId": "wavesandbox.com!w+fZPSm_lQA", 
        "content": "\n", 
        "parentBlipId": null
      }, 
      "proxyingFor": "douwe"
    }, 
    "method": "wavelet.appendBlip", 
    "id": "op2"
  }, 
  {
    "params": {
      "blipId": "TBD_wavesandbox.com!conv+root_0x4f8595d846f3fa72",
      "waveletId": "wavesandbox.com!conv+root", 
      "waveId": "wavesandbox.com!w+fZPSm_lQA", 
      "modifyAction": {
        "modifyHow": "INSERT_AFTER", 
        "values": ["hi from douwe"]
      }, 
      "proxyingFor": "douwe"
    }, 
    "method": "document.modify", 
    "id": "op3"
  }
]
=end
=begin
[
  {
    "method":"robot.notifyCapabilitiesHash",
    "id":"0",
    "params":{
      "protocolVersion":"0.21",
      "capabilitiesHash":"811f1864387db4dcfe4afb9365407d7d6f4239fb"
    }
  },
  {
    "method":"wavelet.appendBlip",
    "id":"op2",
    "params":{
      "waveletId":"wavesandbox.com!conv+root",
      "waveId":"wavesandbox.com!w+eZg2gbjgA",
      "blipData":{
        "waveletId":"wavesandbox.com!conv+root",
        "blipId":"TBD_wavesandbox.com!conv+root_4b4e5",
        "waveId":"wavesandbox.com!w+eZg2gbjgA",
        "parentBlipId":null,
        "content":"\n"
      },
      "proxyingFor":"douwe"
    }
  },
  {
    "method":"document.modify",
    "id":"op3",
    "params":{
      "waveletId":"wavesandbox.com!conv+root",
      "blipId":"TBD_wavesandbox.com!conv+root_4b4e5",
      "waveId":"wavesandbox.com!w+eZg2gbjgA",
      "modifyAction":{
        "modifyHow":"INSERT_AFTER",
        "values":["hi from douwe"]
      },
      "proxyingFor":"douwe"
    }
  }
]
=end
end

robot.start
