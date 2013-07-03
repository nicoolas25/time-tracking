module TimeTracking
  class Cake
    include Contracts::DSL

    attr_accessor :identifier
    attr_accessor :size
    # attr_accessor :slices
    # attr_accessor :parent

    def initialize(identifier, size=INFINITE_SIZE)
      tc!(identifier, String) and tc!(size, Float)
      sat!('size must be positive', size >= 0)

      @identifier = identifier
      @size       = size
      @slices     = []
    end

    def remaining_size
      return INFINITE_SIZE if size == INFINITE_SIZE
      result = slices.reduce(size){ |rs, slice| rs - slice.size }
      sat!('remaining size must be positive', result >= 0)
      result
    end

    def slice_for!(eater, slice_size=nil)
      tc!(slice_size, Float, true) and tc!(eater, Eater)
      slices << (slice = Slice.new(self, eater, slice_size))
      sat!('last element of slices must be the newly created slice', slices.last == slice)
      slice
    end

    def total_slices_size
      slices.reduce(EMPTY_SIZE){ |bs, s| bs + s.size }
    end

    def bitten_size
      slices.reduce(EMPTY_SIZE){ |bs, s| bs + s.bitten_size }
    end

    def unexpected_bitten_size
      slices.reduce(EMPTY_SIZE){ |bs, s| bs + s.unexpected_bitten_size }
    end

    def to_s
      "<Cake:nammed(#{identifier}),size(#{size})>"
    end
  end
end

