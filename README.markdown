Ruby Wave Robot API
===================

What is this
------------

This library allows you to develop a wave robot with Ruby language and to run it on any server other than GAE.

Note
----

This library is under construction. The sample in this file is the only code I've confirmed to work.

* Events
  * WaveletSelfAdded
  * WaveletParticipantsChanged
  * BlipSubmitted
* Action
  * wavelet.reply
  * blip.append
  * blip.insert_inline_blip
  * robot.new_wave
  * wavelet.append_markup
  * wavelet.submit_with

How to try the sample on [Heroku](http://code.google.com/intl/ja/apis/wave/extensions/robots/registration.html)
-------------------------------

1. Register your robot's domain in accordance with:
   [http://code.google.com/intl/ja/apis/wave/extensions/robots/registration.html](http://code.google.com/intl/ja/apis/wave/extensions/robots/registration.html)

2. Push all files to your heroku repository

3. Add your robot to a wave as a participant

Sample
------

    require 'rubygems'
    require 'sinatra'
    require 'waveapi'

    robot = Waveapi::Robot.new(
      'Ruby Robot', 
      :base_url => '/sample-robot', 
      :image_url => 'http://ruby-wave-robot-api.heroku.com/images/icon.png',
      :profile_url => 'http://ruby-wave-robot-api.heroku.com'
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

    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      blip = event.blip

      wavelet.title = 'A wavelet title'

      blip.append(Waveapi::Image.new('http://www.google.com/logos/clickortreat1.gif', 320, 118))

      wavelet.proxy_for('douwe').reply().append('hi from douwe')

      inline_blip = blip.insert_inline_blip(5)
      inline_blip.append('hello again!')

      new_wave = robot.new_wave(wavelet.domain, wavelet.participants, :message => wavelet.to_s)
      new_wave.root_blip.append('A new day and a new wave')
      new_wave.root_blip.append_markup('<p>Some stuff!</p><p>Not the <b>beautiful</b></p>') 
      new_wave.submit_with(wavelet)
    end

    robot.start

Contact
-------
Ando Yasushi (andyjpn _at_ gmail.com)

* [http://reviewmycode.blogspot.com/](http://reviewmycode.blogspot.com/)
* [http://d.hatena.ne.jp/technohippy/](http://d.hatena.ne.jp/technohippy/)
* [http://twitter.com/technohippy](http://twitter.com/technohippy)
