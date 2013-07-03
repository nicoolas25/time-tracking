module TimeTracking
  class Eater
    include Contracts::DSL

    attr_accessor :identifier
    # attr_accessor :slices

    def initialize(_identifier)
      @identifier = _identifier
      @slices     = []
    end

    def receive_slice(slice)
      slices << slice
      sat!('last element of slices must be the given slice', slices.last == slice)
    end

    def open_slices
      slices.select(&:open?)
    end

    def to_s
      "<Eater:nammed(#{identifier})>"
    end
  end
end
