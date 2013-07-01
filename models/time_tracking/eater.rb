module TimeTracking
  class Eater
    include Contracts::DSL

    attr_reader   :identifier
    attr_accessor :slices

    def initialize(identifier)
      @identifier = identifier
      @slices     = []
    end

    def receive_slice(slice)
      slices << slice
      sat!('last element of slices must be the given slice', slices.last == slice)
    end

    def to_s
      "<Eater:nammed(#{identifier})>"
    end
  end
end
