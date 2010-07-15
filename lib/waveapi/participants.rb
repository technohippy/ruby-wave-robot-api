module Waveapi
  class Participants
    ROLE_FULL = 'FULL'
    ROLE_READ_ONLY = 'READ_ONLY'

    def initialize(participants, roles, wave_id, wavelet_id, context)
      @participants = participants
      @roles = roles.dup
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @context = context
    end

    def include?(participant)
      @participants.include?(participant)
    end

    def size
      @participants.size
    end

    def each(&block)
      @participants.each(&block)
    end

    def add_participant(participant_id)
      operation = WaveletAddParticipantOperation.new(@wave_id, @wavelet_id, participant_id)
      @context.add_operation(operation)
      @participants << participant_id
    end
    alias << add_participant

    def get_role(participant_id)
      @roles[participant_id] || ROLE_FULL
    end

    def set_role(participant_id, role)
      unless [ROLE_FULL, ROLE_READ_ONLY].include?(role)
        raise ArgumentError.new("Invalid role: #{role}")
      end
      operation = WaveletModifyParticipantRoleOperation.new(@wave_id, @wavelet_id, 
        participant_id, role)
      @context.add_operation(operation)
      @roles[participant_id] = role
    end
  end
end
