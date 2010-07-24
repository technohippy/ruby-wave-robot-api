require 'waveapi'

=begin
  it 'wavelet.title=' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      wavelet.reply("hello")
    end

    incoming_json = ''

    outgoing_json = JSON.parse('')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = ''
    result_json.should eql(outgoing_json)
  end
=end

describe Waveapi do
  it 'Gadget' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      blip = event.blip
      gadget = blip.first(Waveapi::Gadget, :url => 'http://kitchensinky.appspot.com/public/embed.xml')
      if (gadget and gadget.get('loaded', 'no') == 'yes' and gadget.get('seen', 'no') == 'no') 
        gadget.update_element('seen' => 'yes')
      end
      blip.append("\nSeems all to have worked out.")
      image = blip.first(Waveapi::Image)
      image.update_element('url' => 'http://www.google.com/logos/poppy09.gif')
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279557420217,"properties":{"blipId":"b+Vc2tsgj3B"}}],"wavelet":{"creationTime":1279557386693,"lastModifiedTime":1279557420217,"version":35,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com","ruby-teacher.on-wave+proxy@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","ruby-teacher.on-wave+proxy@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Vc2tsgj3B","title":"A wavelet title","waveId":"googlewave.com!w+Vc2tsgj3A","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Vc2tsgj3B":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":17}},{"name":"lang","value":"en","range":{"start":0,"end":17}},{"name":"spell","value":"sp+sFOWYbZkLAZ\nf\nwa","range":{"start":3,"end":5}},{"name":"lang","value":"unknown","range":{"start":17,"end":20}},{"name":"lang","value":"en","range":{"start":20,"end":43}}],"elements":{"17":{"type":"LINE","properties":{}},"0":{"type":"LINE","properties":{}},"19":{"type":"GADGET","properties":{"loaded":"yes","first":"yes","url":"http://kitchensinky.appspot.com/public/embed.xml"}},"18":{"type":"IMAGE","properties":{"height":"118","width":"320","url":"http://www.google.com/logos/clickortreat1.gif"}},"20":{"type":"LINE","properties":{}},"5":{"type":"INLINE_BLIP","properties":{"id":"b+Wmrw0bZkBRT"}}},"blipId":"b+Vc2tsgj3B","childBlipIds":["b+Wmrw0bZkBRS","b+Wmrw0bZkBRT"],"contributors":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"creator":"andyjpn@googlewave.com","content":"\nA wa velet title\n  \nInserted a gadget: абв","lastModifiedTime":1279557419668,"parentBlipId":null,"version":34,"waveId":"googlewave.com!w+Vc2tsgj3A","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null},"b+Wmrw0bZkBRS":{"annotations":[{"name":"lang","value":"en","range":{"start":0,"end":14}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Wmrw0bZkBRS","childBlipIds":[],"contributors":["ruby-teacher.on-wave+proxy@appspot.com"],"creator":"ruby-teacher.on-wave+proxy@appspot.com","content":"\nhi from douwe","lastModifiedTime":1279557403568,"parentBlipId":"b+Vc2tsgj3B","version":13,"waveId":"googlewave.com!w+Vc2tsgj3A","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null},"b+Wmrw0bZkBRT":{"annotations":[{"name":"lang","value":"en","range":{"start":0,"end":13}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Wmrw0bZkBRT","childBlipIds":[],"contributors":["ruby-teacher.on-wave@appspot.com"],"creator":"ruby-teacher.on-wave@appspot.com","content":"\nhello again!","lastModifiedTime":1279557403571,"parentBlipId":"b+Vc2tsgj3B","version":19,"waveId":"googlewave.com!w+Vc2tsgj3A","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse(<<-'end_of_json')
[
  {
    "params": {
      "capabilitiesHash": "0x34df52e", 
      "protocolVersion": "0.21"
    }, 
    "method": "robot.notifyCapabilitiesHash", 
    "id": "0"
  }, 
  {
    "params": {
      "blipId": "b+Vc2tsgj3B", 
      "waveletId": "googlewave.com!conv+root", 
      "waveId": "googlewave.com!w+Vc2tsgj3A", 
      "modifyAction": {
        "modifyHow": "UPDATE_ELEMENT", 
        "elements": [
          {
            "type": "GADGET", 
            "properties": {"url": null, "seen": "yes"}
          }
        ]
      }, 
      "modifyQuery": {
        "restrictions": {
          "url": "http://kitchensinky.appspot.com/public/embed.xml"
        }, 
        "maxRes": 1, 
        "elementMatch": "GADGET"
      }
    }, 
    "method": "document.modify", 
    "id": "op13"
  }, 
  {
    "params": {
      "blipId": "b+Vc2tsgj3B", 
      "waveletId": "googlewave.com!conv+root", 
      "waveId": "googlewave.com!w+Vc2tsgj3A", 
      "modifyAction": {
        "modifyHow": "INSERT_AFTER", 
        "values": ["\nSeems all to have worked out."]
      }
    }, 
    "method": "document.modify", 
    "id": "op14"
  }, 
  {
    "params": {
      "blipId": "b+Vc2tsgj3B", 
      "waveletId": "googlewave.com!conv+root", 
      "waveId": "googlewave.com!w+Vc2tsgj3A", 
      "modifyAction": {
        "modifyHow": "UPDATE_ELEMENT", 
        "elements": [
          {
            "type": "IMAGE", 
            "properties": {"url": "http://www.google.com/logos/poppy09.gif"}
          }
        ]
      }, 
      "modifyQuery": {
        "restrictions": {}, 
        "maxRes": 1, 
        "elementMatch": "IMAGE"
      }
    }, 
    "method": "document.modify", 
    "id": "op15"
  }
]
    end_of_json

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0x34df52e'
    result_json[1]['id'] = 'op13'
    result_json[1]['params']['modifyAction']['elements'][0]['properties']['url'] = nil
    result_json[2]['id'] = 'op14'
    result_json[3]['id'] = 'op15'
    result_json.should eql(outgoing_json)
  end

  it 'wavelet created event' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::WaveletCreatedEvent) do |event, wavelet|
      org_wavelet = wavelet.robot.blind_wavelet(event.message)
      gadget = Waveapi::Gadget.new('http://kitchensinky.appspot.com/public/embed.xml') 
      gadget.waveid = wavelet.wave_id
      org_wavelet.root_blip.append(gadget)
      org_wavelet.root_blip.append("\nInserted a gadget: hello")
      org_wavelet.submit_with(wavelet)
    end

    incoming_json = '{"events":[{"type":"WAVELET_CREATED","modifiedBy":"ruby-teacher.on-wave@appspot.com","timestamp":1279380107995,"properties":{"blipId":"b+_7MqCLZkBe9","message":"{\"rootBlipId\": \"b+0t1inwdOB\", \"creator\": \"andyjpn@googlewave.com\", \"blips\": {\"TBD_googlewave.com!conv+root_0x78ad28287d0e0e17\": {\"blipId\": \"TBD_googlewave.com!conv+root_0x78ad28287d0e0e17\", \"waveletId\": \"googlewave.com!conv+root\", \"elements\": {}, \"contributors\": [], \"creator\": null, \"parentBlipId\": null, \"annotations\": [], \"content\": \"\\nhi from douwe\", \"version\": 0, \"lastModifiedTime\": 0, \"childBlipIds\": [], \"waveId\": \"googlewave.com!w+0t1inwdOA\"}, \"b+0t1inwdOB\": {\"blipId\": \"b+0t1inwdOB\", \"waveletId\": \"googlewave.com!conv+root\", \"elements\": {\"0\": {\"type\": \"LINE\", \"properties\": {}}, \"17\": {\"type\": \"IMAGE\", \"properties\": {\"url\": \"http://www.google.com/logos/clickortreat1.gif\", \"width\": 320, \"height\": 118}}}, \"contributors\": [\"andyjpn@googlewave.com\"], \"creator\": \"andyjpn@googlewave.com\", \"parentBlipId\": null, \"annotations\": [{\"range\": {\"start\": 1, \"end\": 1}, \"name\": \"user/e/0t1inwdO\", \"value\": \"andyjpn@googlewave.com\"}, {\"range\": {\"start\": 0, \"end\": 1}, \"name\": \"conv/title\", \"value\": \"\"}, {\"range\": {\"start\": 0, \"end\": 1}, \"name\": \"user/d/0t1inwdO\", \"value\": \"andyjpn@googlewave.com,1279380090505,\"}], \"content\": \"\\nA wavelet title\\n \", \"version\": 5, \"lastModifiedTime\": 1279380091259, \"childBlipIds\": [], \"waveId\": \"googlewave.com!w+0t1inwdOA\"}}, \"title\": \"A wavelet title\", \"creationTime\": 1279380091260, \"dataDocuments\": {}, \"waveletId\": \"googlewave.com!conv+root\", \"participants\": [\"ruby-teacher.on-wave@appspot.com\", \"andyjpn@googlewave.com\", \"ruby-teacher.on-wave+proxy@appspot.com\"], \"waveId\": \"googlewave.com!w+0t1inwdOA\", \"lastModifiedTime\": 1279380107658}","waveId":"googlewave.com!w+_7MqCLZkBe8","waveletId":"googlewave.com!conv+root"}}],"wavelet":{"creationTime":1279380107993,"lastModifiedTime":1279380107998,"version":0,"participants":["ruby-teacher.on-wave@appspot.com","andyjpn@googlewave.com","ruby-teacher.on-wave+proxy@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","ruby-teacher.on-wave+proxy@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"rusty@a.gwave.com","rootBlipId":"b+_7MqCLZkBe9","title":"","waveId":"googlewave.com!w+_7MqCLZkBe8","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+_7MqCLZkBe9":{"annotations":[{"name":"style/fontWeight","value":"bold","range":{"start":45,"end":54}}],"elements":{"0":{"type":"LINE","properties":{}},"36":{"type":"LINE","properties":{}}},"blipId":"b+_7MqCLZkBe9","childBlipIds":[],"contributors":["ruby-teacher.on-wave@appspot.com"],"creator":"ruby-teacher.on-wave@appspot.com","content":"\nA new day and a new waveSome stuff!\nNot the beautiful","lastModifiedTime":1279380107998,"parentBlipId":null,"version":0,"waveId":"googlewave.com!w+_7MqCLZkBe8","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0x1054531", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"blipId": "b+0t1inwdOB", "waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+0t1inwdOA", "modifyAction": {"modifyHow": "INSERT_AFTER", "elements": [{"type": "GADGET", "properties": {"url": "http://kitchensinky.appspot.com/public/embed.xml"}}]}}, "method": "document.modify", "id": "op11"}, {"params": {"blipId": "b+0t1inwdOB", "waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+0t1inwdOA", "modifyAction": {"modifyHow": "INSERT_AFTER", "values": ["\nInserted a gadget: hello"]}}, "method": "document.modify", "id": "op12"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0x1054531'
    result_json[1]['id'] = 'op11'
    result_json[2]['id'] = 'op12'
    result_json.should eql(outgoing_json)
  end

  it 'new_wave' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      new_wave = robot.new_wave(wavelet.domain, wavelet.participants, wavelet.to_json)
      new_wave.root_blip.append('A new day and a new wave')
      new_wave.root_blip.append_markup('<p>Some stuff!</p><p>Not the <b>beautiful</b></p>') 
      new_wave.submit_with(wavelet)
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279206259104,"properties":{"blipId":"b+22A6jx4SB"}}],"wavelet":{"creationTime":1279206076685,"lastModifiedTime":1279206259104,"version":14,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+22A6jx4SB","title":"","waveId":"googlewave.com!w+22A6jx4SA","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+22A6jx4SB":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+22A6jx4SB","childBlipIds":[],"contributors":["andyjpn@googlewave.com"],"creator":"andyjpn@googlewave.com","content":"\n","lastModifiedTime":1279206076677,"parentBlipId":null,"version":5,"waveId":"googlewave.com!w+22A6jx4SA","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'


      #"message": "{\"rootBlipId\": \"b+22A6jx4SB\", \"creator\": \"andyjpn@googlewave.com\", \"blips\": {\"b+22A6jx4SB\": {\"blipId\": \"b+22A6jx4SB\", \"waveletId\": \"googlewave.com!conv+root\", \"elements\": {\"0\": {\"type\": \"LINE\", \"properties\": {}}}, \"contributors\": [\"andyjpn@googlewave.com\"], \"creator\": \"andyjpn@googlewave.com\", \"parentBlipId\": null, \"annotations\": [{\"range\": {\"start\": 0, \"end\": 1}, \"name\": \"conv/title\", \"value\": \"\"}], \"content\": \"\\n\", \"version\": 5, \"lastModifiedTime\": 1279206076677, \"childBlipIds\": [], \"waveId\": \"googlewave.com!w+22A6jx4SA\"}}, \"title\": \"\", \"creationTime\": 1279206076685, \"dataDocuments\": {}, \"waveletId\": \"googlewave.com!conv+root\", \"participants\": [\"ruby-teacher.on-wave@appspot.com\", \"andyjpn@googlewave.com\"], \"waveId\": \"googlewave.com!w+22A6jx4SA\", \"lastModifiedTime\": 1279206259104}"
    message = JSON.parse("{\"rootBlipId\": \"b+22A6jx4SB\", \"creator\": \"andyjpn@googlewave.com\", \"blips\": {\"b+22A6jx4SB\": {\"blipId\": \"b+22A6jx4SB\", \"waveletId\": \"googlewave.com!conv+root\", \"elements\": {\"0\": {\"type\": \"LINE\", \"properties\": {}}}, \"contributors\": [\"andyjpn@googlewave.com\"], \"creator\": \"andyjpn@googlewave.com\", \"parentBlipId\": null, \"annotations\": [{\"range\": {\"start\": 0, \"end\": 1}, \"name\": \"conv/title\", \"value\": \"\"}], \"content\": \"\\\\n\", \"version\": 5, \"lastModifiedTime\": 1279206076677, \"childBlipIds\": [], \"waveId\": \"googlewave.com!w+22A6jx4SA\"}}, \"title\": \"\", \"creationTime\": 1279206076685, \"dataDocuments\": null, \"waveletId\": \"googlewave.com!conv+root\", \"participants\": [\"ruby-teacher.on-wave@appspot.com\", \"andyjpn@googlewave.com\"], \"waveId\": \"googlewave.com!w+22A6jx4SA\", \"lastModifiedTime\": 1279206259104}").to_json.gsub('"', '\"')#.gsub('\n', '\\n').sub('\"dataDocuments\":null', '\"dataDocuments\":{}')

    outgoing_json = JSON.parse(<<-end_of_json)
[
  {
    "params": {
      "capabilitiesHash": "0xd49798", 
      "protocolVersion": "0.21"
    }, 
    "method": "robot.notifyCapabilitiesHash", 
    "id": "0"
  }, 
  {
    "params": {
      "waveletId": "googlewave.com!conv+root", 
      "waveletData": {
        "waveletId": "googlewave.com!conv+root", 
        "waveId": "googlewave.com!TBD_0x54adc8d02194a0a4", 
        "rootBlipId": "TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6", 
        "participants": ["ruby-teacher.on-wave@appspot.com", "andyjpn@googlewave.com"]
      }, 
      "waveId": "googlewave.com!TBD_0x54adc8d02194a0a4", 
      "message": "#{message}"
    }, 
    "method": "robot.createWavelet", 
    "id": "op1"
  }, 
  {
    "params": {
      "blipId": "TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6", 
      "waveletId": "googlewave.com!conv+root", 
      "waveId": "googlewave.com!TBD_0x54adc8d02194a0a4", 
      "modifyAction": {
        "modifyHow": "INSERT_AFTER", 
        "values": ["A new day and a new wave"]
      }
    }, 
    "method": "document.modify", 
    "id": "op2"
  }, 
  {
    "params": {
      "blipId": "TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6", 
      "content": "<p>Some stuff!</p><p>Not the <b>beautiful</b></p>", 
      "waveId": "googlewave.com!TBD_0x54adc8d02194a0a4", 
      "waveletId": "googlewave.com!conv+root"
    }, 
    "method": "document.appendMarkup", 
    "id": "op3"
  }
]
    end_of_json

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json[1]['params']['waveId'] = 'googlewave.com!TBD_0x54adc8d02194a0a4'
    result_json[1]['params']['waveletData']['waveId'] = 'googlewave.com!TBD_0x54adc8d02194a0a4'
    result_json[1]['params']['waveletData']['rootBlipId'] = 'TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6'
    result_json[2]['params']['waveId'] = 'googlewave.com!TBD_0x54adc8d02194a0a4'
    result_json[2]['params']['blipId'] = 'TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6'
    result_json[3]['params']['waveId'] = 'googlewave.com!TBD_0x54adc8d02194a0a4'
    result_json[3]['params']['blipId'] = 'TBD_googlewave.com!conv+root_0x16a17bc9e7c917f6'
    result_json.should eql(outgoing_json)
  end

  it 'participants changed' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::WaveletParticipantsChangedEvent) do |event, wavelet|
      new_participants = event.participants_added
      new_participants.each do |new_participant|
        wavelet.reply("\nHi : #{new_participant}")
      end
    end

    incoming_json = '{"events":[{"type":"WAVELET_SELF_ADDED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279125906505,"properties":{"blipId":"b+Mg1By4lSJ"}},{"type":"WAVELET_PARTICIPANTS_CHANGED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279125906505,"properties":{"blipId":"b+Mg1By4lSJ","participantsAdded":["ruby-teacher.on-wave@appspot.com"],"participantsRemoved":[]}}],"wavelet":{"creationTime":1279125768512,"lastModifiedTime":1279125906505,"version":8,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSJ","title":"","waveId":"googlewave.com!w+Mg1By4lSI","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSJ":{"annotations":[{"name":"user/d/Mg1By4lS","value":"andyjpn@googlewave.com,1279125768217,","range":{"start":0,"end":1}},{"name":"conv/title","value":"","range":{"start":0,"end":1}},{"name":"user/e/Mg1By4lS","value":"andyjpn@googlewave.com","range":{"start":1,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSJ","childBlipIds":[],"contributors":["andyjpn@googlewave.com"],"creator":"andyjpn@googlewave.com","content":"\n","lastModifiedTime":1279125768511,"parentBlipId":null,"version":5,"waveId":"googlewave.com!w+Mg1By4lSI","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd0d9c75", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSI", "blipData": {"waveletId": "googlewave.com!conv+root", "blipId": "TBD_googlewave.com!conv+root_0x7d184e3c6084a641", "waveId": "googlewave.com!w+Mg1By4lSI", "content": "\nHi : ruby-teacher.on-wave@appspot.com", "parentBlipId": null}}, "method": "wavelet.appendBlip", "id": "op1"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd0d9c75'
    result_json[1]['params']['blipData']['blipId'] = 'TBD_googlewave.com!conv+root_0x7d184e3c6084a641'
    result_json.should eql(outgoing_json)
  end

  it 'inline_blip.append' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      blip = event.blip
      inline_blip = blip.insert_inline_blip(5)
      inline_blip.append('hello again!')
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279123095058,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279123095058,"version":98,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"aa","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":3}},{"name":"lang","value":"unknown","range":{"start":0,"end":14}}],"elements":{"0":{"type":"LINE","properties":{}},"3":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"creator":"andyjpn@googlewave.com","content":"\naa\naaaaaaaaaa","lastModifiedTime":1279123093816,"parentBlipId":null,"version":96,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"blipId": "b+Mg1By4lSD", "index": 5, "waveId": "googlewave.com!w+Mg1By4lSC", "blipData": {"waveletId": "googlewave.com!conv+root", "blipId": "TBD_googlewave.com!conv+root_0x7da1805c596e8f8d", "waveId": "googlewave.com!w+Mg1By4lSC", "content": "", "parentBlipId": "b+Mg1By4lSD"}, "waveletId": "googlewave.com!conv+root"}, "method": "document.inlineBlip.insert", "id": "op1"}, {"params": {"blipId": "TBD_googlewave.com!conv+root_0x7da1805c596e8f8d", "waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "modifyAction": {"modifyHow": "INSERT_AFTER", "values": ["hello again!"]}}, "method": "document.modify", "id": "op2"}]')

    json = robot.handle(incoming_json)
    result_json = JSON.parse(json)
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json[1]['params']['blipData']['blipId'] = 'TBD_googlewave.com!conv+root_0x7da1805c596e8f8d'
    result_json[2]['params']['blipId'] = 'TBD_googlewave.com!conv+root_0x7da1805c596e8f8d'
    result_json.should eql(outgoing_json)
  end

  it 'wavelet.proxy_for.reply.append' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      wavelet.proxy_for('douwe').reply().append('hi from douwe')
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279122547179,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279122547179,"version":70,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"creator":"andyjpn@googlewave.com","content":"\n","lastModifiedTime":1279122544490,"parentBlipId":null,"version":66,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "participantId": "ruby-teacher.on-wave+douwe@appspot.com"}, "method": "wavelet.participant.add", "id": "op1"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "blipData": {"waveletId": "googlewave.com!conv+root", "blipId": "TBD_googlewave.com!conv+root_0x3a5214de6ae8c0c7", "waveId": "googlewave.com!w+Mg1By4lSC", "content": "\n", "parentBlipId": null}, "proxyingFor": "douwe"}, "method": "wavelet.appendBlip", "id": "op2"}, {"params": {"blipId": "TBD_googlewave.com!conv+root_0x3a5214de6ae8c0c7", "waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "modifyAction": {"modifyHow": "INSERT_AFTER", "values": ["hi from douwe"]}, "proxyingFor": "douwe"}, "method": "document.modify", "id": "op3"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json[2]['params']['blipData']['blipId'] = 'TBD_googlewave.com!conv+root_0x3a5214de6ae8c0c7'
    result_json[3]['params']['blipId'] = 'TBD_googlewave.com!conv+root_0x3a5214de6ae8c0c7'
    result_json.should eql(outgoing_json)
  end

  it 'blip.append(Image)' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      event.blip.append(Waveapi::Image.new('http://www.google.com/logos/clickortreat1.gif', 320, 118))
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279122274210,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279122274210,"version":48,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"A wavelet title","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":16}},{"name":"lang","value":"en","range":{"start":0,"end":16}}],"elements":{"0":{"type":"LINE","properties":{}},"16":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"creator":"andyjpn@googlewave.com","content":"\nA wavelet title\n","lastModifiedTime":1279119087694,"parentBlipId":null,"version":42,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"blipId": "b+Mg1By4lSD", "waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "modifyAction": {"modifyHow": "INSERT_AFTER", "elements": [{"type": "IMAGE", "properties": {"url": "http://www.google.com/logos/clickortreat1.gif", "width": 320, "height": 118}}]}}, "method": "document.modify", "id": "op1"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json.should eql(outgoing_json)
  end

  it 'wavelet.title=' do 
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      wavelet.title = 'A wavelet title'
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279119087616,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279119087616,"version":41,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}},"1":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"creator":"andyjpn@googlewave.com","content":"\n\n","lastModifiedTime":1279119086585,"parentBlipId":null,"version":36,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "waveletTitle": "A wavelet title"}, "method": "wavelet.setTitle", "id": "op1"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json.should eql(outgoing_json)
  end

  it 'wavelet.reply' do
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      wavelet.reply("hello")
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279113378038,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279113378038,"version":10,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com"],"creator":"andyjpn@googlewave.com","content":"\n","lastModifiedTime":1279113360747,"parentBlipId":null,"version":5,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "0xd49798", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "blipData": {"waveletId": "googlewave.com!conv+root", "blipId": "TBD_googlewave.com!conv+root_", "waveId": "googlewave.com!w+Mg1By4lSC", "content": "hello", "parentBlipId": null}}, "method": "wavelet.appendBlip", "id": "op1"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json[0]['params']['capabilitiesHash'] = '0xd49798'
    result_json[1]['params']['blipData']['blipId'] = 'TBD_googlewave.com!conv+root_'
    result_json.should eql(outgoing_json)
  end
end
