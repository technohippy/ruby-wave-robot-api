NOTE
====

This library is under construction. The following sample is the only code I've confirmed to work.

Sample
======

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
    end

    robot.start
