require 'waveapi'

describe Waveapi do
  it 'wavelet.reply' do
    robot = Waveapi::Robot.new('Test Robot')
    robot.register_handler(Waveapi::BlipSubmittedEvent) do |event, wavelet|
      wavelet.reply("hello")
    end

    incoming_json = '{"events":[{"type":"BLIP_SUBMITTED","modifiedBy":"andyjpn@googlewave.com","timestamp":1279113378038,"properties":{"blipId":"b+Mg1By4lSD"}}],"wavelet":{"creationTime":1279113360748,"lastModifiedTime":1279113378038,"version":10,"participants":["andyjpn@googlewave.com","ruby-teacher.on-wave@appspot.com"],"participantRoles":{"ruby-teacher.on-wave@appspot.com":"FULL","andyjpn@googlewave.com":"FULL"},"dataDocuments":{},"tags":[],"creator":"andyjpn@googlewave.com","rootBlipId":"b+Mg1By4lSD","title":"","waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","rootThread":null},"blips":{"b+Mg1By4lSD":{"annotations":[{"name":"conv/title","value":"","range":{"start":0,"end":1}}],"elements":{"0":{"type":"LINE","properties":{}}},"blipId":"b+Mg1By4lSD","childBlipIds":[],"contributors":["andyjpn@googlewave.com"],"creator":"andyjpn@googlewave.com","content":"\n","lastModifiedTime":1279113360747,"parentBlipId":null,"version":5,"waveId":"googlewave.com!w+Mg1By4lSC","waveletId":"googlewave.com!conv+root","replyThreadIds":[],"threadId":null}},"threads":{},"robotAddress":"ruby-teacher.on-wave@appspot.com"}'

    outgoing_json = JSON.parse('[{"params": {"capabilitiesHash": "", "protocolVersion": "0.21"}, "method": "robot.notifyCapabilitiesHash", "id": "0"}, {"params": {"waveletId": "googlewave.com!conv+root", "waveId": "googlewave.com!w+Mg1By4lSC", "blipData": {"waveletId": "googlewave.com!conv+root", "blipId": "TBD_googlewave.com!conv+root_", "waveId": "googlewave.com!w+Mg1By4lSC", "content": "hello", "parentBlipId": null}}, "method": "wavelet.appendBlip", "id": "op1"}]')

    result_json = JSON.parse(robot.handle(incoming_json))
    result_json.first['params']['capabilitiesHash'] = ''
    result_json.last['params']['blipData']['blipId'] = 'TBD_googlewave.com!conv+root_'
    result_json.should eql(outgoing_json)
  end
end
