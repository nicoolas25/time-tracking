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

    def bites
      slices.reduce([]){ |b, s| b += s.bites }.sort_by(&:occured_at)
    end

    def to_s
      "<Eater:nammed(#{identifier})>"
    end
  end
end
